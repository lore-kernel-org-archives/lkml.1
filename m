Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbZDUSkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbZDUSkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758544AbZDUSjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:39:44 -0400
Received: from eazy.amigager.de ([213.239.192.238]:53167 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581AbZDUSjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:39:41 -0400
Date: Tue, 21 Apr 2009 20:39:36 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: 2.6.29 regression: left audio channel broken after resume from
	suspend with Intel HDA
Message-ID: <20090421183936.GA21935@dose.home.local>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
References: <20090420184024.GA10155@dose.home.local> <s5hmyab15bh.wl%tiwai@suse.de> <20090420194659.GA11399@dose.home.local> <s5h8wluinon.wl%tiwai@suse.de> <20090421073219.GA5866@dose.home.local> <s5hfxg2cv6m.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <s5hfxg2cv6m.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 21, 2009 at 09:39:13 +0200, Takashi Iwai wrote:
> At Tue, 21 Apr 2009 09:32:19 +0200,
> Tino Keitel wrote:
> > 
> > On Tue, Apr 21, 2009 at 07:24:40 +0200, Takashi Iwai wrote:
> > > The commit is fcad94a4c71c36a05f4d5c6dcb174534b4e0b136:
> > >     ALSA: hda - Fix the cmd cache keys for amp verbs
> > 
> > Thanks for the reply. However, the patch doesn't work. I just got
> > distorted sound again.
> 
> Then please run alsa-info.sh (with --no-upload option) before and
> after suspend, and attach the generated files.  Also, check the latest
> Linus tree whether the problem still appears.

My first impression with suspend seems to be wrong. It also sometimes
happens just after a while, event without suspend.

Attached are 2 alsa-info.sh outputs. One was taken after I noticed the
distorted sound, one after I reloaded snd-hda-intel to fix the
distortion. The mixer seems to be quite different after module reload.

Regards,
Tino

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="alsa-left-channel-distorted.txt"

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.52
!!################################

!!Script ran on: Tue Apr 21 20:23:11 CEST 2009


!!Linux Distribution
!!------------------

Debian GNU/Linux squeeze/sid \n \l


!!Kernel Information
!!------------------

Kernel release:    2.6.29.1
Operating System:  GNU/Linux
Architecture:      x86_64
Processor:         unknown
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.18a
Library version:    1.0.19
Utilities version:  1.0.19


!!Loaded ALSA modules
!!-------------------



!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0x90440000 irq 22


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)


!!Advanced information - PCI Vendor/Device/Susbsystem ID's
!!--------------------------------------------------------

00:1b.0 0403: 8086:27d8 (rev 02)
	Subsystem: 8384:7680


!!Modprobe options (Sound related)
!!--------------------------------

snd-atiixp-modem: index=-2
snd-intel8x0m: index=-2
snd-via82xx-modem: index=-2
snd-pcsp: index=-2


!!Loaded sound module options
!!--------------------------


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: SigmaTel STAC9221 A1
Address: 0
Vendor Id: 0x83847680
Subsystem Id: 0x106b0800
Revision Id: 0x103601
No Modem Function Group found
Default PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: ofs=0x00, nsteps=0x0e, stepsize=0x05, mute=1
Default Amp-Out caps: ofs=0x7f, nsteps=0x7f, stepsize=0x02, mute=1
GPIO: io=4, o=0, i=0, unsolicited=1, wake=1
  IO[0]: enable=1, dir=1, wake=0, sticky=0, data=1, unsol=0
  IO[1]: enable=1, dir=1, wake=0, sticky=0, data=1, unsol=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out R/L
  Amp-Out caps: N/A
  Amp-Out vals:  [0x64 0x64]
  Converter: stream=5, channel=0
  Power: setting=D0, actual=D0
  Delay: 13 samples
Node 0x03 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out R/L
  Amp-Out caps: N/A
  Amp-Out vals:  [0xff 0xff]
  Converter: stream=5, channel=0
  Power: setting=D0, actual=D0
  Delay: 13 samples
Node 0x04 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out R/L
  Amp-Out caps: N/A
  Amp-Out vals:  [0xff 0xff]
  Converter: stream=0, channel=0
  Power: setting=D0, actual=D0
  Delay: 13 samples
Node 0x05 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out R/L
  Amp-Out caps: N/A
  Amp-Out vals:  [0xff 0xff]
  Converter: stream=0, channel=0
  Power: setting=D0, actual=D0
  Delay: 13 samples
Node 0x06 [Audio Input] wcaps 0x1d0541: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  Power: setting=D0, actual=D0
  Delay: 13 samples
  Connection: 1
     0x17
  Processing caps: benign=0, ncoeff=0
Node 0x07 [Audio Input] wcaps 0x1d0541: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  Power: setting=D0, actual=D0
  Delay: 13 samples
  Connection: 1
     0x18
  Processing caps: benign=0, ncoeff=0
Node 0x08 [Audio Output] wcaps 0x40211: Stereo Digital
  Converter: stream=5, channel=0
  Digital: Enabled
  Digital category: 0x0
  PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 4 samples
Node 0x09 [Audio Input] wcaps 0x140311: Stereo Digital
  Converter: stream=0, channel=0
  SDI-Select: 0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 4 samples
  Connection: 1
     0x11
Node 0x0a [Pin Complex] wcaps 0x400181: Stereo
  Pincap 0x0000173f: IN OUT HP Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x0121e21f: [Jack] HP Out at Ext Rear
    Conn = 1/8, Color = White
    DefAssociation = 0x1, Sequence = 0xf
  Pin-ctls: 0xc0: OUT HP VREF_HIZ
  Unsolicited: tag=01, enabled=1
  Connection: 1
     0x02
Node 0x0b [Pin Complex] wcaps 0x400181: Stereo
  Pincap 0x00001737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x400000ff: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0xf
  Pin-ctls: 0x20: IN VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x04
Node 0x0c [Pin Complex] wcaps 0x400181: Stereo
  Pincap 0x00001737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x9017e110: [Fixed] Speaker at Int N/A
    Conn = Analog, Color = White
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x03
Node 0x0d [Pin Complex] wcaps 0x400181: Stereo
  Pincap 0x0000173f: IN OUT HP Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x400000fd: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0xd
  Pin-ctls: 0x40: OUT VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x02
Node 0x0e [Pin Complex] wcaps 0x400081: Stereo
  Pincap 0x00000024: IN Detect
  Pin Default 0x400000fe: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0xe
  Pin-ctls: 0x20: IN
  Unsolicited: tag=00, enabled=0
Node 0x0f [Pin Complex] wcaps 0x400181: Stereo
  Pincap 0x00000037: IN OUT Detect Trigger ImpSense
  Pin Default 0x0181e020: [Jack] Line In at Ext Rear
    Conn = 1/8, Color = White
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0x60: IN OUT
  Unsolicited: tag=02, enabled=1
  Connection: 1
     0x05
Node 0x10 [Pin Complex] wcaps 0x400301: Stereo Digital
  Pincap 0x00000010: OUT
  Pin Default 0x1145e030: [Jack] SPDIF Out at Int Rear
    Conn = Optical, Color = White
    DefAssociation = 0x3, Sequence = 0x0
  Pin-ctls: 0x40: OUT
  Connection: 3
     0x08* 0x17 0x19
Node 0x11 [Pin Complex] wcaps 0x430681: Stereo Digital
  Pincap 0x00010024: IN EAPD Detect
  EAPD 0x0:
  Pin Default 0x11c5e240: [Jack] SPDIF In at Int Rear
    Conn = Optical, Color = White
    DefAssociation = 0x4, Sequence = 0x0
  Pin-ctls: 0x20: IN
  Unsolicited: tag=00, enabled=0
  Power: setting=D0, actual=D0
  Delay: 3 samples
Node 0x12 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 7
     0x0e 0x15 0x0f* 0x0b 0x0c 0x0d 0x0a
Node 0x13 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 7
     0x0e 0x15 0x0f* 0x0b 0x0c 0x0d 0x0a
Node 0x14 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Amp-Out caps: ofs=0x03, nsteps=0x03, stepsize=0x17, mute=0
  Amp-Out vals:  [0x00]
Node 0x15 [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x00000020: IN
  Pin Default 0x400000fc: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0xc
  Pin-ctls: 0x00:
Node 0x16 [Volume Knob Widget] wcaps 0x600000: Mono
  Volume-Knob: delta=1, steps=127, direct=1, val=127
  Connection: 4
     0x02 0x03 0x04 0x05
Node 0x17 [Audio Selector] wcaps 0x300903: Stereo Amp-In R/L
  Amp-In caps: N/A
  Amp-In vals:  [0x80 0x80]
  Connection: 1
     0x12
Node 0x18 [Audio Selector] wcaps 0x300903: Stereo Amp-In R/L
  Amp-In caps: N/A
  Amp-In vals:  [0x80 0x80]
  Connection: 1
     0x13
Node 0x19 [Vendor Defined Widget] wcaps 0xf30201: Stereo Digital
  Delay: 3 samples
Node 0x1a [Audio Output] wcaps 0x30201: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  Delay: 3 samples
Node 0x1b [Pin Complex] wcaps 0x400301: Stereo Digital
  Pincap 0x00000010: OUT
  Pin Default 0x400000fb: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0xb
  Pin-ctls: 0x00:
  Connection: 1
     0x1a
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw---- 1 root audio 116,  0 Apr 21 08:45 /dev/snd/controlC0
crw-rw---- 1 root audio 116, 24 Apr 21 09:53 /dev/snd/pcmC0D0c
crw-rw---- 1 root audio 116, 16 Apr 21 20:22 /dev/snd/pcmC0D0p
crw-rw---- 1 root audio 116, 25 Apr 21 08:45 /dev/snd/pcmC0D1c
crw-rw---- 1 root audio 116, 17 Apr 21 09:51 /dev/snd/pcmC0D1p
crw-rw---- 1 root audio 116, 33 Apr 21 08:45 /dev/snd/timer


!!ALSA configuration files
!!------------------------

!!User specific config file (~/.asoundrc)

    pcm.!default {
        type pulse
    }

    ctl.!default {
        type pulse
    }



!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC92xx Analog [STAC92xx Analog]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 1: STAC92xx Digital [STAC92xx Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC92xx Analog [STAC92xx Analog]
  Subdevices: 2/2
  Subdevice #0: subdevice #0
  Subdevice #1: subdevice #1
card 0: Intel [HDA Intel], device 1: STAC92xx Digital [STAC92xx Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0x90440000 irq 22'
  Mixer name	: 'SigmaTel STAC9221 A1'
  Components	: 'HDA:83847680,106b0800,00103601'
  Controls      : 20
  Simple ctrls  : 12
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
  Playback channels: Mono
  Limits: Playback 0 - 127
  Mono: Playback 127 [100%] [0.00dB] [on]
Simple mixer control 'Headphone',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 127
  Mono:
  Front Left: Playback 100 [79%] [-20.25dB] [on]
  Front Right: Playback 100 [79%] [-20.25dB] [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 255
  Mono:
  Front Left: Playback 255 [100%] [0.00dB]
  Front Right: Playback 255 [100%] [0.00dB]
Simple mixer control 'IEC958',0
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'IEC958 Default PCM',0
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 14
  Front Left: Capture 0 [0%] [0.00dB] [off]
  Front Right: Capture 0 [0%] [0.00dB] [off]
Simple mixer control 'Capture',1
  Capabilities: cvolume cswitch
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 14
  Front Left: Capture 0 [0%] [0.00dB] [off]
  Front Right: Capture 0 [0%] [0.00dB] [off]
Simple mixer control 'Input Source',0
  Capabilities: cenum
  Items: 'Line'
  Item0: 'Line'
Simple mixer control 'Input Source',1
  Capabilities: cenum
  Items: 'Line'
  Item0: 'Line'
Simple mixer control 'Mux',0
  Capabilities: cvolume
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 2
  Front Left: Capture 0 [0%] [0.00dB]
  Front Right: Capture 0 [0%] [0.00dB]
Simple mixer control 'Mux',1
  Capabilities: cvolume
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 4
  Front Left: Capture 0 [0%] [0.00dB]
  Front Right: Capture 0 [0%] [0.00dB]
Simple mixer control 'Speaker',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 127
  Mono:
  Front Left: Playback 127 [100%] [0.00dB] [off]
  Front Right: Playback 127 [100%] [0.00dB] [off]


!!Alsactl output
!!-------------

--startcollapse--
state.Intel {
	control.1 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Line
		iface MIXER
		name 'Input Source'
		value Line
	}
	control.2 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Line
		iface MIXER
		name 'Input Source'
		index 1
		value Line
	}
	control.3 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 14'
		comment.dbmin 0
		comment.dbmax 2100
		iface MIXER
		name 'Capture Volume'
		value.0 0
		value.1 0
	}
	control.4 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		value.0 false
		value.1 false
	}
	control.5 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 14'
		comment.dbmin 0
		comment.dbmax 2100
		iface MIXER
		name 'Capture Volume'
		index 1
		value.0 0
		value.1 0
	}
	control.6 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 1
		value.0 false
		value.1 false
	}
	control.7 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 127'
		comment.dbmin -9525
		comment.dbmax 0
		iface MIXER
		name 'Speaker Playback Volume'
		value.0 127
		value.1 127
	}
	control.8 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Speaker Playback Switch'
		value.0 false
		value.1 false
	}
	control.9 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 127'
		comment.dbmin -9525
		comment.dbmax 0
		iface MIXER
		name 'Headphone Playback Volume'
		value.0 100
		value.1 100
	}
	control.10 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Headphone Playback Switch'
		value.0 true
		value.1 true
	}
	control.11 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 2'
		comment.dbmin 0
		comment.dbmax 2000
		iface MIXER
		name 'Mux Capture Volume'
		value.0 0
		value.1 0
	}
	control.12 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 4'
		comment.dbmin 0
		comment.dbmax 4000
		iface MIXER
		name 'Mux Capture Volume'
		index 1
		value.0 0
		value.1 0
	}
	control.13 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Con Mask'
		value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.14 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Pro Mask'
		value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.15 {
		comment.access 'read write'
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Default'
		value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.16 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Switch'
		value true
	}
	control.17 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Default PCM Playback Switch'
		value true
	}
	control.18 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 127'
		comment.dbmin -9525
		comment.dbmax 0
		iface MIXER
		name 'Master Playback Volume'
		value 127
	}
	control.19 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Master Playback Switch'
		value true
	}
	control.20 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 255'
		comment.tlv '0000000100000008ffffec1400000014'
		comment.dbmin -5100
		comment.dbmax 0
		iface MIXER
		name 'PCM Playback Volume'
		value.0 255
		value.1 255
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
dvb_usb_vp7045
i915
fb
drm
i2c_algo_bit
cfbcopyarea
cfbimgblt
cfbfillrect
ipv6
loop
dvb_usb
dvb_core
firewire_sbp2
snd_hda_codec_idt
snd_hda_intel
snd_hda_codec
snd_pcm_oss
snd_mixer_oss
firewire_ohci
snd_pcm
firewire_core
snd_timer
snd_page_alloc
crc_itu_t
sky2
usblp



--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="alsa-left-channel-ok.txt"

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.52
!!################################

!!Script ran on: Tue Apr 21 20:27:34 CEST 2009


!!Linux Distribution
!!------------------

Debian GNU/Linux squeeze/sid \n \l


!!Kernel Information
!!------------------

Kernel release:    2.6.29.1
Operating System:  GNU/Linux
Architecture:      x86_64
Processor:         unknown
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.18a
Library version:    1.0.19
Utilities version:  1.0.19


!!Loaded ALSA modules
!!-------------------



!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0x90440000 irq 22


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)


!!Advanced information - PCI Vendor/Device/Susbsystem ID's
!!--------------------------------------------------------

00:1b.0 0403: 8086:27d8 (rev 02)
	Subsystem: 8384:7680


!!Modprobe options (Sound related)
!!--------------------------------

snd-atiixp-modem: index=-2
snd-intel8x0m: index=-2
snd-via82xx-modem: index=-2
snd-pcsp: index=-2


!!Loaded sound module options
!!--------------------------


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: SigmaTel STAC9221 A1
Address: 0
Vendor Id: 0x83847680
Subsystem Id: 0x100
Revision Id: 0x103601
No Modem Function Group found
Default PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: ofs=0x00, nsteps=0x0e, stepsize=0x05, mute=1
Default Amp-Out caps: ofs=0x7f, nsteps=0x7f, stepsize=0x02, mute=1
GPIO: io=4, o=0, i=0, unsolicited=1, wake=1
  IO[0]: enable=1, dir=1, wake=0, sticky=0, data=1, unsol=0
  IO[1]: enable=1, dir=1, wake=0, sticky=0, data=1, unsol=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out R/L
  Amp-Out caps: N/A
  Amp-Out vals:  [0xff 0xff]
  Converter: stream=5, channel=0
  Power: setting=D0, actual=D0
  Delay: 13 samples
Node 0x03 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out R/L
  Amp-Out caps: N/A
  Amp-Out vals:  [0xff 0xff]
  Converter: stream=5, channel=0
  Power: setting=D0, actual=D0
  Delay: 13 samples
Node 0x04 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out R/L
  Amp-Out caps: N/A
  Amp-Out vals:  [0xff 0xff]
  Converter: stream=0, channel=0
  Power: setting=D0, actual=D0
  Delay: 13 samples
Node 0x05 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out R/L
  Amp-Out caps: N/A
  Amp-Out vals:  [0xff 0xff]
  Converter: stream=0, channel=0
  Power: setting=D0, actual=D0
  Delay: 13 samples
Node 0x06 [Audio Input] wcaps 0x1d0541: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  Power: setting=D0, actual=D0
  Delay: 13 samples
  Connection: 1
     0x17
  Processing caps: benign=0, ncoeff=0
Node 0x07 [Audio Input] wcaps 0x1d0541: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  Power: setting=D0, actual=D0
  Delay: 13 samples
  Connection: 1
     0x18
  Processing caps: benign=0, ncoeff=0
Node 0x08 [Audio Output] wcaps 0x40211: Stereo Digital
  Converter: stream=5, channel=0
  Digital: Enabled
  Digital category: 0x0
  PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 4 samples
Node 0x09 [Audio Input] wcaps 0x140311: Stereo Digital
  Converter: stream=0, channel=0
  SDI-Select: 0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 4 samples
  Connection: 1
     0x11
Node 0x0a [Pin Complex] wcaps 0x400181: Stereo
  Pincap 0x0000173f: IN OUT HP Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x0321e21f: [Jack] HP Out at Ext Left
    Conn = 1/8, Color = White
    DefAssociation = 0x1, Sequence = 0xf
  Pin-ctls: 0xc0: OUT HP VREF_HIZ
  Unsolicited: tag=01, enabled=1
  Connection: 1
     0x02
Node 0x0b [Pin Complex] wcaps 0x400181: Stereo
  Pincap 0x00001737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x03a1e02e: [Jack] Mic at Ext Left
    Conn = 1/8, Color = White
    DefAssociation = 0x2, Sequence = 0xe
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=02, enabled=1
  Connection: 1
     0x04
Node 0x0c [Pin Complex] wcaps 0x400181: Stereo
  Pincap 0x00001737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x9017e110: [Fixed] Speaker at Int N/A
    Conn = Analog, Color = White
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x03
Node 0x0d [Pin Complex] wcaps 0x400181: Stereo
  Pincap 0x0000173f: IN OUT HP Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x9017e11f: [Fixed] Speaker at Int N/A
    Conn = Analog, Color = White
    DefAssociation = 0x1, Sequence = 0xf
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x02
Node 0x0e [Pin Complex] wcaps 0x400081: Stereo
  Pincap 0x00000024: IN Detect
  Pin Default 0x400000fe: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0xe
  Pin-ctls: 0x20: IN
  Unsolicited: tag=00, enabled=0
Node 0x0f [Pin Complex] wcaps 0x400181: Stereo
  Pincap 0x00000037: IN OUT Detect Trigger ImpSense
  Pin Default 0x0381e020: [Jack] Line In at Ext Left
    Conn = 1/8, Color = White
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0x60: IN OUT
  Unsolicited: tag=03, enabled=1
  Connection: 1
     0x05
Node 0x10 [Pin Complex] wcaps 0x400301: Stereo Digital
  Pincap 0x00000010: OUT
  Pin Default 0x1345e230: [Jack] SPDIF Out at Int Left
    Conn = Optical, Color = White
    DefAssociation = 0x3, Sequence = 0x0
  Pin-ctls: 0x40: OUT
  Connection: 3
     0x08* 0x17 0x19
Node 0x11 [Pin Complex] wcaps 0x430681: Stereo Digital
  Pincap 0x00010024: IN EAPD Detect
  EAPD 0x0:
  Pin Default 0x13c5e240: [Jack] SPDIF In at Int Left
    Conn = Optical, Color = White
    DefAssociation = 0x4, Sequence = 0x0
  Pin-ctls: 0x20: IN
  Unsolicited: tag=00, enabled=0
  Power: setting=D0, actual=D0
  Delay: 3 samples
Node 0x12 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 7
     0x0e 0x15 0x0f* 0x0b 0x0c 0x0d 0x0a
Node 0x13 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 7
     0x0e 0x15 0x0f* 0x0b 0x0c 0x0d 0x0a
Node 0x14 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Amp-Out caps: ofs=0x03, nsteps=0x03, stepsize=0x17, mute=0
  Amp-Out vals:  [0x00]
Node 0x15 [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x00000020: IN
  Pin Default 0x400000fc: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0xc
  Pin-ctls: 0x00:
Node 0x16 [Volume Knob Widget] wcaps 0x600000: Mono
  Volume-Knob: delta=1, steps=127, direct=1, val=127
  Connection: 4
     0x02 0x03 0x04 0x05
Node 0x17 [Audio Selector] wcaps 0x300903: Stereo Amp-In R/L
  Amp-In caps: N/A
  Amp-In vals:  [0x80 0x80]
  Connection: 1
     0x12
Node 0x18 [Audio Selector] wcaps 0x300903: Stereo Amp-In R/L
  Amp-In caps: N/A
  Amp-In vals:  [0x80 0x80]
  Connection: 1
     0x13
Node 0x19 [Vendor Defined Widget] wcaps 0xf30201: Stereo Digital
  Delay: 3 samples
Node 0x1a [Audio Output] wcaps 0x30201: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  Delay: 3 samples
Node 0x1b [Pin Complex] wcaps 0x400301: Stereo Digital
  Pincap 0x00000010: OUT
  Pin Default 0x400000fb: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0xb
  Pin-ctls: 0x00:
  Connection: 1
     0x1a
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw---- 1 root audio 116,  0 Apr 21 20:25 /dev/snd/controlC0
crw-rw---- 1 root audio 116, 24 Apr 21 20:25 /dev/snd/pcmC0D0c
crw-rw---- 1 root audio 116, 16 Apr 21 20:26 /dev/snd/pcmC0D0p
crw-rw---- 1 root audio 116, 25 Apr 21 20:25 /dev/snd/pcmC0D1c
crw-rw---- 1 root audio 116, 17 Apr 21 20:25 /dev/snd/pcmC0D1p
crw-rw---- 1 root audio 116, 33 Apr 21 08:45 /dev/snd/timer


!!ALSA configuration files
!!------------------------

!!User specific config file (~/.asoundrc)

    pcm.!default {
        type pulse
    }

    ctl.!default {
        type pulse
    }



!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC92xx Analog [STAC92xx Analog]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 1: STAC92xx Digital [STAC92xx Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC92xx Analog [STAC92xx Analog]
  Subdevices: 2/2
  Subdevice #0: subdevice #0
  Subdevice #1: subdevice #1
card 0: Intel [HDA Intel], device 1: STAC92xx Digital [STAC92xx Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0x90440000 irq 22'
  Mixer name	: 'SigmaTel STAC9221 A1'
  Components	: 'HDA:83847680,00000100,00103601'
  Controls      : 20
  Simple ctrls  : 12
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
  Playback channels: Mono
  Limits: Playback 0 - 127
  Mono: Playback 127 [100%] [0.00dB] [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 255
  Mono:
  Front Left: Playback 255 [100%] [0.00dB]
  Front Right: Playback 255 [100%] [0.00dB]
Simple mixer control 'Front',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 127
  Mono:
  Front Left: Playback 127 [100%] [0.00dB] [off]
  Front Right: Playback 127 [100%] [0.00dB] [off]
Simple mixer control 'Surround',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 127
  Mono:
  Front Left: Playback 127 [100%] [0.00dB] [off]
  Front Right: Playback 127 [100%] [0.00dB] [off]
Simple mixer control 'IEC958',0
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'IEC958 Default PCM',0
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 14
  Front Left: Capture 0 [0%] [0.00dB] [off]
  Front Right: Capture 0 [0%] [0.00dB] [off]
Simple mixer control 'Capture',1
  Capabilities: cvolume cswitch
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 14
  Front Left: Capture 0 [0%] [0.00dB] [off]
  Front Right: Capture 0 [0%] [0.00dB] [off]
Simple mixer control 'Input Source',0
  Capabilities: cenum
  Items: 'Mic' 'Line'
  Item0: 'Line'
Simple mixer control 'Input Source',1
  Capabilities: cenum
  Items: 'Mic' 'Line'
  Item0: 'Line'
Simple mixer control 'Mux',0
  Capabilities: cvolume
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 2
  Front Left: Capture 0 [0%] [0.00dB]
  Front Right: Capture 0 [0%] [0.00dB]
Simple mixer control 'Mux',1
  Capabilities: cvolume
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 4
  Front Left: Capture 0 [0%] [0.00dB]
  Front Right: Capture 0 [0%] [0.00dB]


!!Alsactl output
!!-------------

--startcollapse--
state.Intel {
	control.1 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Mic
		comment.item.1 Line
		iface MIXER
		name 'Input Source'
		value Line
	}
	control.2 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Mic
		comment.item.1 Line
		iface MIXER
		name 'Input Source'
		index 1
		value Line
	}
	control.3 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 14'
		comment.dbmin 0
		comment.dbmax 2100
		iface MIXER
		name 'Capture Volume'
		value.0 0
		value.1 0
	}
	control.4 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		value.0 false
		value.1 false
	}
	control.5 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 14'
		comment.dbmin 0
		comment.dbmax 2100
		iface MIXER
		name 'Capture Volume'
		index 1
		value.0 0
		value.1 0
	}
	control.6 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 1
		value.0 false
		value.1 false
	}
	control.7 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 127'
		comment.dbmin -9525
		comment.dbmax 0
		iface MIXER
		name 'Front Playback Volume'
		value.0 127
		value.1 127
	}
	control.8 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Front Playback Switch'
		value.0 false
		value.1 false
	}
	control.9 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 127'
		comment.dbmin -9525
		comment.dbmax 0
		iface MIXER
		name 'Surround Playback Volume'
		value.0 127
		value.1 127
	}
	control.10 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Surround Playback Switch'
		value.0 false
		value.1 false
	}
	control.11 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 2'
		comment.dbmin 0
		comment.dbmax 2000
		iface MIXER
		name 'Mux Capture Volume'
		value.0 0
		value.1 0
	}
	control.12 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 4'
		comment.dbmin 0
		comment.dbmax 4000
		iface MIXER
		name 'Mux Capture Volume'
		index 1
		value.0 0
		value.1 0
	}
	control.13 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Con Mask'
		value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.14 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Pro Mask'
		value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.15 {
		comment.access 'read write'
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Default'
		value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.16 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Switch'
		value true
	}
	control.17 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Default PCM Playback Switch'
		value true
	}
	control.18 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 127'
		comment.dbmin -9525
		comment.dbmax 0
		iface MIXER
		name 'Master Playback Volume'
		value 127
	}
	control.19 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Master Playback Switch'
		value true
	}
	control.20 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 255'
		comment.tlv '0000000100000008ffffec1400000014'
		comment.dbmin -5100
		comment.dbmax 0
		iface MIXER
		name 'PCM Playback Volume'
		value.0 255
		value.1 255
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
snd_hda_intel
dvb_usb_vp7045
i915
fb
drm
i2c_algo_bit
cfbcopyarea
cfbimgblt
cfbfillrect
ipv6
loop
dvb_usb
dvb_core
firewire_sbp2
snd_hda_codec_idt
snd_hda_codec
snd_pcm_oss
snd_mixer_oss
firewire_ohci
snd_pcm
firewire_core
snd_timer
snd_page_alloc
crc_itu_t
sky2
usblp



--VS++wcV0S1rZb1Fb--
