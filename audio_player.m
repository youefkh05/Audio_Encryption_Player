function varargout = audio_player(varargin)
% AUDIO_PLAYER MATLAB code for audio_player.fig
%      AUDIO_PLAYER, by itself, creates a new AUDIO_PLAYER or raises the existing
%      singleton*.
%
%      H = AUDIO_PLAYER returns the handle to a new AUDIO_PLAYER or the handle to
%      the existing singleton*.
%
%      AUDIO_PLAYER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUDIO_PLAYER.M with the given input arguments.
%
%      AUDIO_PLAYER('Property','Value',...) creates a new AUDIO_PLAYER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before audio_player_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to audio_player_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help audio_player

% Last Modified by GUIDE v2.5 14-Aug-2023 22:47:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @audio_player_OpeningFcn, ...
                   'gui_OutputFcn',  @audio_player_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
end
% End initialization code - DO NOT EDIT


% --- Executes just before audio_player is made visible.
function audio_player_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to audio_player (see VARARGIN)

% Choose default command line output for audio_player
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global vfact    %volume factor
global efact    %encryption factor
global rate
global orate    %orignal rate
global ostate
global estate
global dstate
global f
global oy
global ey
global m
global om       %orignal music
global em       %encrypted music
global mpos     %the position of the music
global playm
global file
global path
global closesavef
closesavef=0;
[oy,f]=audioread("saved audio\dafault.mp3");
efact=0.01;
rate=1;
orate=1;
vfact=1;
ostate=1;
estate=0;
dstate=1;
m=0;
playm=0;
om=audioplayer(vfact.*oy,rate.*f);
ey=encrypt_audio(oy,efact);
em=audioplayer(vfact.*ey,rate.*f);
set(handles.oradio,'value',1);
set(handles.eradio,'value',0);
set(handles.dradio,'value',1);
mpos=om.CurrentSample;
path="saved audio\";
file="dafault.mp3";
set(handles.loc,'string',path);
set(handles.fileb,'string',file);
set(handles.rateb,'string',rate);
set(handles.noiseb,'string',efact);
set(handles.volb,'string',vfact);
set(handles.vol,'value',0.5);
set(handles.noise,'value',0.1);
set(handles.saveb,'visible',"off");
set(handles.noise,'visible',"off");
set(handles.noiseb,'visible',"off");
set(handles.ntext,'visible',"off");

ah=axes('unit','normalized','position',[0 0 1 1]);
bg=imread("audio_player_resources\audioLogo.png");
imagesc(bg);
set(ah,'handlevisibility','off','visible','off');
end


% UIWAIT makes audio_player wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = audio_player_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end
% --- Executes on button press in select.
function select_Callback(hObject, eventdata, handles)
% hObject    handle to select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global om       %orignal music
global em       %encrypted music
global vfact    %volume factor
global efact    %encryption factor
global rate     %speed of sound
global f
global oy
global ey
global mpos     %the position of the music
global playm    %check if you play or not
global file
global path
[file,path]=uigetfile();
mp=strcat(path,file);
[oy ,f]=audioread(mp);
stop(om);
stop(em);
om=audioplayer(vfact.*oy,rate.*f);
ey=encrypt_audio(oy,efact);
em=audioplayer(vfact.*ey,rate.*f);
playm=0;
mpos=om.CurrentSample;
set(handles.loc,'string',path);
set(handles.fileb,'string',file);
end


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m
global om       %orignal music
global em       %encrypted music
global playm
global mpos     %the position of the music
stop(em);
stop(om);
mpos=om.CurrentSample;  %restart
if m==0
    play(om);
else
    play(em);
end
playm=1;
end

% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m
global om       %orignal music
global em       %encrypted music
global playm
global mpos     %the position of the music
pause(em);
pause(om);
if m==0
    mpos=om.CurrentSample;
else
    mpos=em.CurrentSample;
end
playm=0;
end 

% --- Executes on button press in resume.
function resume_Callback(hObject, eventdata, handles)
% hObject    handle to resume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m
global om       %orignal music
global em       %encrypted music
global mpos     %the position of the music 
global playm
if m==0
    play(om,mpos);
else
    play(em,mpos);
end
playm=1;
end
% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global om       %orignal music
global em       %encrypted music
global playm
global mpos     %the position of the music
stop(em);
stop(om);
playm=0;    %stop
mpos=om.CurrentSample;  %restart
end
% --- Executes on button press in oradio.
function oradio_Callback(hObject, eventdata, handles)
% hObject    handle to oradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of oradio
global estate
global ostate
global m
global om       %orignal music
global em       %encrypted music
global mpos     %the position of the music 
global playm
set(handles.oradio,'value',1);
ostate=1;
m=0;
if estate==1  %if it is on it will not do anything
set(handles.eradio,'value',0);
estate=0;
mpos=em.CurrentSample;  %save it before you stop it
stop(em);
play(om,mpos);
pause(om);              %just to save the position
if playm==1
    play(om,mpos);
end
end
set(handles.noise,'visible',"off");
set(handles.noiseb,'visible',"off");
set(handles.ntext,'visible',"off");
end


% --- Executes on button press in eradio.
function eradio_Callback(hObject, eventdata, handles)
% hObject    handle to eradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of eradio
global estate
global ostate
global m
global om       %orignal music
global em       %encrypted music
global mpos     %the position of the music 
global playm
set(handles.eradio,'value',1);
estate=1;
m=1;
if ostate==1  %if it is on it will not do anything
set(handles.oradio,'value',0);
ostate=0;
mpos=om.CurrentSample;  %save it before you stop it
stop(om);
play(em,mpos);
pause(em);              %just to save the position
if playm==1
    play(em,mpos);
end
end
set(handles.saveb,'visible',"on");
set(handles.noise,'visible',"on");
set(handles.noiseb,'visible',"on");
set(handles.ntext,'visible',"on");
end
% --- Executes on button press in dradio.
function dradio_Callback(hObject, eventdata, handles)
% hObject    handle to dradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dradio
set(handles.dradio,'value',1);
global vfact    %volume factor
global efact    %encryption factor
global rate     %speed of sound
global playm
global m
global om       %orignal music
global em       %encrypted music
global mpos     %the position of the music
global f
global oy
global ey
global dstate
global orate
if dstate==0 
dstate=1;
if m==0
    mpos= om.CurrentSample; 
else
    mpos= em.CurrentSample;
end
%default mode:
efact=0.01;
rate=orate;
vfact=1;
om=audioplayer(vfact.*oy,rate.*f);
ey=encrypt_audio(oy,efact);
em=audioplayer(vfact.*ey,rate.*f);
play(om,mpos);
pause(om);              %just to save the position
play(em,mpos);
pause(em);              %just to save the position
if playm==1 %playing
    switch m
        case 0
            play(om,mpos);
        case 1
             play(em,mpos);
    end
end
end
set(handles.rateb,'string',rate);
set(handles.noiseb,'string',efact);
set(handles.volb,'string',vfact);
set(handles.vol,'value',0.5);
set(handles.noise,'value',0.1);
end

% --- Executes on button press in fast.
function fast_Callback(hObject, eventdata, handles)
% hObject    handle to fast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vfact    %volume factor
global efact    %encryption factor
global rate     %speed of sound
global playm
global m
global om       %orignal music
global em       %encrypted music
global mpos     %the position of the music
global f
global oy
global ey
global dstate
global orate
set(handles.dradio,'value',0);
dstate=0;
if m==0
    mpos= om.CurrentSample; 
else
    mpos= em.CurrentSample;
end
rate=rate+0.2*orate;
om=audioplayer(vfact.*oy,rate.*f);
ey=encrypt_audio(oy,efact);
em=audioplayer(vfact.*ey,rate.*f);
play(om,mpos);
play(em,mpos);
pause(om);
pause(em);
if playm==1 %playing
    switch m
        case 0
            play(om,mpos);
        case 1
            play(em,mpos);
    end
end
set(handles.rateb,'string',rate);
set(handles.saveb,'visible',"on");
end


% --- Executes on button press in slow.
function slow_Callback(hObject, eventdata, handles)
% hObject    handle to slow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vfact    %volume factor
global efact    %encryption factor
global rate     %speed of sound
global playm
global m
global om       %orignal music
global em       %encrypted music
global mpos     %the position of the music
global f
global oy
global ey
global dstate
global orate
set(handles.dradio,'value',0);
dstate=0;
if m==0
    mpos= om.CurrentSample; 
else
    mpos= em.CurrentSample;
end
rate=rate-0.2*orate;
om=audioplayer(vfact.*oy,rate.*f);
ey=encrypt_audio(oy,efact);
em=audioplayer(vfact.*ey,rate.*f);
play(om,mpos);
play(em,mpos);
pause(om);
pause(em);
if playm==1 %playing
    switch m
        case 0
            play(om,mpos);
        case 1
            play(em,mpos);
    end
end
set(handles.rateb,'string',rate);
set(handles.saveb,'visible',"on");
end
 
% --- Executes on slider movement.
function vol_Callback(hObject, eventdata, handles)
% hObject    handle to vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global vfact    %volume factor
global efact    %encryption factor
global rate     %speed of sound
global playm
global m
global om       %orignal music
global em       %encrypted music
global mpos     %the position of the music
global f
global oy
global ey
global dstate
set(handles.dradio,'value',0);
dstate=0;
if m==0
    mpos= om.CurrentSample; 
else
    mpos= em.CurrentSample;
end
vr=get(hObject,'Value');    %volume read
if vr>=0.5  %increase the vol
   %we need to map as the min input is 0.5 max is 1, output min=1 max=5
   vfact=((vr-0.5)/0.5)*(5-1)+1;
else
   %we need to map as the min input is 0 max is 0.5, output min=0 max=0.2
   vfact=((vr-0)/0.5)*(0.5)+0;
end
om=audioplayer(vfact.*oy,rate.*f);
ey=encrypt_audio(oy,efact);
em=audioplayer(vfact.*ey,rate.*f);
play(om,mpos);
play(em,mpos);
pause(om);
pause(em);
if playm==1 %playing
    switch m
        case 0
            play(om,mpos);
        case 1
            play(em,mpos);
    end
end
set(handles.volb,'string',vfact);
set(handles.saveb,'visible',"on");
end


% --- Executes during object creation, after setting all properties.
function vol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end


% --- Executes on slider movement.
function noise_Callback(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global vfact
global efact    %encryption factor
global rate     %speed of sound
global playm
global m
global om       %orignal music
global em       %encrypted music
global mpos     %the position of the music
global f
global oy
global ey
global dstate
set(handles.dradio,'value',0);
dstate=0;
if m==0
    mpos= om.CurrentSample; 
else
    mpos= em.CurrentSample;
end
nr=get(hObject,'Value');    %noise read
%we need to map as the min input is 0 max is 1, output min=0 max=0.1
efact=((nr-0)/1)*(0.1-0)+0;
om=audioplayer(vfact.*oy,rate.*f);
ey=encrypt_audio(oy,efact);
em=audioplayer(vfact.*ey,rate.*f);
play(om,mpos);
play(em,mpos);
pause(om);
pause(em);
if playm==1 %playing
    switch m
        case 0
            play(om,mpos);
        case 1
            play(em,mpos);
    end
end
set(handles.noiseb,'string',efact);
set(handles.saveb,'visible',"on");
set(handles.noise,'visible',"on");
set(handles.noiseb,'visible',"on");
set(handles.ntext,'visible',"on");
end

% --- Executes during object creation, after setting all properties.
function noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end


function loc_Callback(hObject, eventdata, handles)
% hObject    handle to loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of loc as text
%        str2double(get(hObject,'String')) returns contents of loc as a double
end

% --- Executes during object creation, after setting all properties.
function loc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function fileb_Callback(hObject, eventdata, handles)
% hObject    handle to fileb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileb as text
%        str2double(get(hObject,'String')) returns contents of fileb as a double
end

% --- Executes during object creation, after setting all properties.
function fileb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function rateb_Callback(hObject, eventdata, handles)
% hObject    handle to rateb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rateb as text
%        str2double(get(hObject,'String')) returns contents of rateb as a double
end

% --- Executes during object creation, after setting all properties.
function rateb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rateb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function noiseb_Callback(hObject, eventdata, handles)
% hObject    handle to noiseb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noiseb as text
%        str2double(get(hObject,'String')) returns contents of noiseb as a double
end

% --- Executes during object creation, after setting all properties.
function noiseb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noiseb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function volb_Callback(hObject, eventdata, handles)
% hObject    handle to volb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of volb as text
%        str2double(get(hObject,'String')) returns contents of volb as a double

end

% --- Executes during object creation, after setting all properties.
function volb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in saveb.
function saveb_Callback(hObject, eventdata, handles)
% hObject    handle to saveb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vfact
global rate     %speed of sound
global f
global oy
global ey
global m
global om
global em
global closesavef
global savedfile
global ext
sm=audioplayer(vfact*oy,rate*f); %saved audio
msgbox("Choose the path to save the audio","Attention");
pause(3);
path=uigetdir();
savefigure=openfig("saveAudio.fig");
while closesavef==0
    %to delay
    pause(0.5);
end
closesavef=0; %to restart
close(savefigure);
savedfilep=path+"\"+savedfile; %file path
%normal audio
if m==0
    audiowrite(savedfilep,vfact*oy,rate*f);
else
    audiowrite(savedfilep,vfact*ey,rate*f);
    sm=audioplayer(vfact*ey,rate*f);
end
msgbox("The audio is saved","Message");
pause(3);
pause(om);
pause(em);
stop(sm);
play(sm);
pause(5);
pause(sm);
end
