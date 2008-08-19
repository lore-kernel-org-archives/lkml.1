Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbYHSW6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbYHSW6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYHSWyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:54:46 -0400
Received: from lucidpixels.com ([75.144.35.66]:44807 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171AbYHSWyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:54:45 -0400
Date: Tue, 19 Aug 2008 18:54:44 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: User discussion about IVTV <ivtv-users@ivtvdriver.org>
cc: Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org
Subject: Re: [ivtv-users] Hauppauge 1192 WinTV-HVR-1950: Kernel Oops :(
In-Reply-To: <alpine.DEB.1.10.0808191823470.15091@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0808191845320.15091@p34.internal.lan>
References: <alpine.DEB.1.10.0808191631030.8579@p34.internal.lan> <alpine.DEB.1.10.0808191752590.12937@p34.internal.lan> <alpine.DEB.1.10.0808191823470.15091@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Aug 2008, Justin Piszcz wrote:

>
> On Tue, 19 Aug 2008, Justin Piszcz wrote:
>
>> On Tue, 19 Aug 2008, Justin Piszcz wrote:
>>
>>> 2.6.26.2:
>>>
>>> [   15.745116] usbcore: registered new interface driver pvrusb2
>>> [   16.023474] pvrusb2: Device initialization completed successfully.
>>
>> Closer now:
>>
>> [  749.791189] pvrusb2: Device initialization completed successfully.
> Cannot seek backward in linear streams!
> Seek failed
> ID_VIDEO_ID=0
> MPEG-PS file format detected.
> ID_AUDIO_ID=0
> VIDEO:  MPEG2  720x480  (aspect 2)  29.970 fps  8000.0 kbps (1000.0 kbyte/s)
> ID_FILENAME=/dev/video0
> ID_DEMUXER=mpegps
> ID_VIDEO_FORMAT=0x10000002
> ID_VIDEO_BITRATE=8000000
> ID_VIDEO_WIDTH=720
> ID_VIDEO_HEIGHT=480
> ID_VIDEO_FPS=29.970
> ID_VIDEO_ASPECT=0.0000
> ID_AUDIO_FORMAT=80
> ID_AUDIO_BITRATE=0
> ID_AUDIO_RATE=0
> ID_AUDIO_NCH=0
> ID_LENGTH=0.00
> ID_SEEKABLE=1
> Opening video filter: [eq2]
> ==========================================================================
> Opening video decoder: [mpegpes] MPEG 1/2 Video passthrough
> VDec: vo config request - 720 x 480 (preferred colorspace: Mpeg PES)
> Could not find matching colorspace - retrying with -vf scale...
> Opening video filter: [scale]
> The selected video_out device is incompatible with this codec.
> Try appending the scale filter to your filter list,
> e.g. -vf spp,scale instead of -vf spp.
> VDecoder init failed :(
> Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
> Selected video codec: [ffmpeg2] vfm: ffmpeg (FFmpeg MPEG-2)
> ==========================================================================
> ID_VIDEO_CODEC=ffmpeg2
> ==========================================================================
> Opening audio decoder: [mp3lib] MPEG layer-2, layer-3
> AUDIO: 48000 Hz, 2 ch, s16le, 224.0 kbit/14.58% (ratio: 28000->192000)
> ID_AUDIO_BITRATE=224000
> ID_AUDIO_RATE=48000
> ID_AUDIO_NCH=2
> Selected audio codec: [mp3] afm: mp3lib (mp3lib MPEG layer-2, layer-3)
> ==========================================================================
> AO: [alsa] 48000Hz 2ch s16le (2 bytes per sample)
> ID_AUDIO_CODEC=mp3
> Starting playback...
> VDec: vo config request - 720 x 480 (preferred colorspace: Planar YV12)
> VDec: using Planar YV12 as output csp (no 0)
> Movie-Aspect is 1.33:1 - prescaling to correct movie aspect.
> ID_VIDEO_ASPECT=1.3333
> VO: [xv] 720x480 => 720x540 Planar YV12
> No bind found for key 'MOUSE_BTN0'.                         0.6% 0 0
> No bind found for key 'MOUSE_BTN0'.                         0.6% 0 0
>
>

Still need to get audio working, video working though by default kernel-module
loading upon boot.  Mplayer with tv:// does not work well, I guess I need 
some USB audio drivers possibly?  Looking into it now.

Also it does not work before xawtv does some 'magic' when I select 
s-video etc, will need to look into that further later.  Then mplayer
will show the stream.

Justin.

