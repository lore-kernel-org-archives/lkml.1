Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbZKJU4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbZKJU4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbZKJU4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:56:47 -0500
Received: from winfree.gag.com ([192.133.104.8]:57657 "EHLO winfree.gag.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758173AbZKJU4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:56:44 -0500
Subject: Re: problem with codec discovery on HP 2530p
From: Bdale Garbee <bdale@gag.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <s5hy6mel48j.wl%tiwai@suse.de>
References: <20091110145338.A55E719D7AD@rover.gag.com>
	 <s5hy6mel48j.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 15:56:38 -0500
Message-ID: <1257886598.4701.3.camel@rover>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 17:43 +0100, Takashi Iwai wrote:

> Could you give alsa-info.sh output (run with --no-upload option)
> on the working (2.6.30.x) kernel?
> 
> Also, what module options do you give to snd-hda-intel?

None intentionally.  Will include alsa-info.sh output for 2.6.32-rc6 too
since it appears to show the module options in use.

Bdale

====== alsa-info output on 2.6.30.9 =====

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.58
!!################################

!!Script ran on: Tue Nov 10 18:56:05 UTC 2009


!!Linux Distribution
!!------------------

Debian GNU/Linux squeeze/sid \n \l


!!DMI Information
!!---------------

Manufacturer:      Hewlett-Packard
Product Name:      HP EliteBook 2530p


!!Kernel Information
!!------------------

Kernel release:    2.6.30.9-64
Operating System:  GNU/Linux
Architecture:      x86_64
Processor:         unknown
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.20
Library version:    1.0.21a
Utilities version:  1.0.21


!!Loaded ALSA modules
!!-------------------



!!Sound Servers on this system
!!----------------------------

aRts:
      Installed - Yes (/usr/bin/artsd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xd4820000 irq 30


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 03)


!!Advanced information - PCI Vendor/Device/Susbsystem ID's
!!--------------------------------------------------------

00:1b.0 0403: 8086:293e (rev 03)
	Subsystem: 103c:30e1


!!Modprobe options (Sound related)
!!--------------------------------

snd-atiixp-modem: index=-2
snd-intel8x0m: index=-2
snd-via82xx-modem: index=-2
snd-pcsp: index=-2
snd-hda-intel: enable_msi=1
snd-hda-intel: single_cmd=1
snd-hda-intel: model=laptop


!!Loaded sound module options
!!--------------------------


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: Analog Devices AD1984A
Address: 0
Function Id: 0x1
Vendor Id: 0x11d4194a
Subsystem Id: 0x103c30e1
Revision Id: 0x100400
No Modem Function Group found
Default PCM:
    rates [0x7ff]: 8000 11025 16000 22050 32000 44100 48000 88200 96000
176400 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
Default Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
GPIO: io=3, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=1, unsol=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0x30211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 3 samples
Node 0x03 [Audio Output] wcaps 0x405: Stereo Amp-Out
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
  Amp-Out vals:  [0x27 0x27]
  Converter: stream=0, channel=0
  Power: setting=D0, actual=D3
Node 0x04 [Audio Output] wcaps 0x405: Stereo Amp-Out
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
  Amp-Out vals:  [0x27 0x27]
  Converter: stream=0, channel=0
  Power: setting=D0, actual=D3
Node 0x05 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x06 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x07 [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x00 0x00]
  Connection: 2
     0x22 0x21
Node 0x08 [Audio Input] wcaps 0x100501: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  Power: setting=D0, actual=D3
  Connection: 1
     0x0c
Node 0x09 [Audio Input] wcaps 0x100501: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  Power: setting=D0, actual=D3
  Connection: 1
     0x0d
Node 0x0a [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x00 0x00]
  Connection: 2
     0x04 0x21
Node 0x0b [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x00 0x00]
  Connection: 2
     0x0f 0x21
Node 0x0c [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x27, nsteps=0x36, stepsize=0x05, mute=1
  Amp-Out vals:  [0x2f 0x2f]
  Connection: 6
     0x14 0x15* 0x16 0x20 0x25 0x17
Node 0x0d [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x27, nsteps=0x36, stepsize=0x05, mute=1
  Amp-Out vals:  [0x80 0x80]
  Connection: 6
     0x14* 0x15 0x16 0x20 0x25 0x17
Node 0x0e [Audio Selector] wcaps 0x300101: Stereo
  Connection: 2
     0x03* 0x04
Node 0x0f [Audio Selector] wcaps 0x300101: Stereo
  Connection: 2
     0x03* 0x04
Node 0x10 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Amp-Out caps: ofs=0x0f, nsteps=0x0f, stepsize=0x0b, mute=1
  Amp-Out vals:  [0x00]
Node 0x11 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000001f: OUT HP Detect Trigger ImpSense
  Pin Default 0x04212040: [Jack] HP Out at Ext Right
    Conn = 1/8, Color = Grey
    DefAssociation = 0x4, Sequence = 0x0
  Pin-ctls: 0xc0: OUT HP
  Unsolicited: tag=37, enabled=1
  Connection: 1
     0x07
Node 0x12 [Pin Complex] wcaps 0x40058d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0001001f: OUT HP EAPD Detect Trigger ImpSense
  EAPD 0x0:
  Pin Default 0x01014010: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Green
    DefAssociation = 0x1, Sequence = 0x0
  Pin-ctls: 0xc0: OUT HP
  Unsolicited: tag=00, enabled=0
  Power: setting=D0, actual=D0
  Connection: 1
     0x0a
Node 0x13 [Pin Complex] wcaps 0x40050c: Mono Amp-Out
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x00]
  Pincap 0x00010010: OUT EAPD
  EAPD 0x0:
  Pin Default 0x413711f0: [N/A] CD at Ext Rear
    Conn = Analog, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Power: setting=D0, actual=D0
  Connection: 1
     0x1f
Node 0x14 [Pin Complex] wcaps 0x40008b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x03 0x03]
  Pincap 0x00003727: IN Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x04a12060: [Jack] Mic at Ext Right
    Conn = 1/8, Color = Grey
    DefAssociation = 0x6, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=36, enabled=1
Node 0x15 [Pin Complex] wcaps 0x40008b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Pincap 0x00003727: IN Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x91a7112e: [Fixed] Mic at Int Rear
    Conn = Analog, Color = Black
    DefAssociation = 0x2, Sequence = 0xe
    Misc = NO_PRESENCE
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
Node 0x16 [Pin Complex] wcaps 0x40058d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x00010037: IN OUT EAPD Detect Trigger ImpSense
  EAPD 0x2: EAPD
  Pin Default 0x9217411f: [Fixed] Speaker at Int Front
    Conn = Analog, Color = Green
    DefAssociation = 0x1, Sequence = 0xf
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Power: setting=D0, actual=D0
  Connection: 1
     0x0b
Node 0x17 [Pin Complex] wcaps 0x40020b: Stereo Digital Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x17, mute=0
  Amp-In vals:  [0x00 0x00]
  Pincap 0x00000020: IN
  Pin Default 0x41a6e130: [N/A] Mic at Ext Rear
    Conn = Digital, Color = White
    DefAssociation = 0x3, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x24: IN
Node 0x18 [Vendor Defined Widget] wcaps 0xf00100: Mono
  Connection: 1
     0x06
Node 0x19 [Power Widget] wcaps 0x500500: Mono
  Power: setting=D0, actual=D0
  Connection: 2
     0x20 0x21
Node 0x1a [Pin Complex] wcaps 0x400000: Mono
  Pincap 0x00000020: IN
  Pin Default 0x90f711f0: [Fixed] Other at Int N/A
    Conn = Analog, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x1b [Pin Complex] wcaps 0x40038d: Stereo Digital Amp-Out
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=1
  Amp-Out vals:  [0x27 0x27]
  Pincap 0x00000014: OUT Detect
  Pin Default 0x41561150: [N/A] Digital Out at Ext Rear
    Conn = Digital, Color = Black
    DefAssociation = 0x5, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x02
Node 0x1c [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x00003737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x01813021: [Jack] Line In at Ext Rear
    Conn = 1/8, Color = Blue
    DefAssociation = 0x2, Sequence = 0x1
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x24
Node 0x1d [Vendor Defined Widget] wcaps 0xf00100: Mono
  Connection: 25
     0x07* 0x0a 0x0b 0x0c 0x0d 0x0e 0x0f 0x11 0x12 0x13 0x14 0x15 0x16
0x19 0x1a 0x1c 0x1e 0x1f 0x20 0x21 0x22 0x23 0x24 0x25 0x26
Node 0x1e [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x00 0x00]
  Connection: 2
     0x0e 0x21
Node 0x1f [Audio Mixer] wcaps 0x200100: Mono
  Connection: 1
     0x1e
Node 0x20 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80
0x80] [0x17 0x17] [0x97 0x97]
  Connection: 7
     0x14 0x15 0x16 0x1a 0x25 0x03 0x04
Node 0x21 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x18 0x18]
  Connection: 1
     0x20
Node 0x22 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 2
     0x03* 0x04
Node 0x23 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 2
     0x03* 0x04
Node 0x24 [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80]
  Connection: 2
     0x23 0x21
Node 0x25 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 1
     0x1c
Node 0x26 [Vendor Defined Widget] wcaps 0xf00100: Mono
  Connection: 3
     0x14* 0x15 0x1c
Node 0x27 [Vendor Defined Widget] wcaps 0xf00301: Stereo Digital
  Connection: 2
     0x08* 0x09
Node 0x28 [Vendor Defined Widget] wcaps 0xf0030d: Stereo Digital Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Connection: 2
     0x08* 0x09
Node 0x29 [Vendor Defined Widget] wcaps 0xf0030d: Stereo Digital Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Connection: 2
     0x08* 0x09
Node 0x2a [Vendor Defined Widget] wcaps 0xf00301: Stereo Digital
  Connection: 2
     0x01* 0x27
Codec: LSI ID 1040
Address: 1
Function Id: 0x2
Vendor Id: 0x11c11040
Subsystem Id: 0x103c1378
Revision Id: 0x100200
Modem Function Group: 0x1
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw---- 1 root audio 116,  0 Nov 10 13:54 /dev/snd/controlC0
crw-rw---- 1 root audio 116,  4 Nov 10 13:54 /dev/snd/hwC0D0
crw-rw---- 1 root audio 116,  5 Nov 10 13:54 /dev/snd/hwC0D1
crw-rw---- 1 root audio 116, 24 Nov 10 13:54 /dev/snd/pcmC0D0c
crw-rw---- 1 root audio 116, 16 Nov 10 13:54 /dev/snd/pcmC0D0p
crw-rw---- 1 root audio 116, 33 Nov 10 13:54 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root  60 Nov 10 13:54 .
drwxr-xr-x 3 root root 180 Nov 10 13:54 ..
lrwxrwxrwx 1 root root  12 Nov 10 13:54 pci-0000:00:1b.0 -> ../controlC0


!!ALSA configuration files
!!------------------------

!!User specific config file (~/.asoundrc)

              pcm.copy {
                type plug
                slave {
                  pcm hw
                }
                route_policy copy
              }



!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: AD198x Analog [AD198x Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: AD198x Analog [AD198x Analog]
  Subdevices: 2/2
  Subdevice #0: subdevice #0
  Subdevice #1: subdevice #1

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0xd4820000 irq 30'
  Mixer name	: 'Analog Devices AD1984A'
  Components	: 'HDA:11d4194a,103c30e1,00100400
HDA:11c11040,103c1378,00100200'
  Controls      : 23
  Simple ctrls  : 15
Simple mixer control 'Master',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 24 [77%] [-10.50dB] [on]
  Front Right: Playback 24 [77%] [-10.50dB] [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 23
  Mono:
  Front Left: Playback 23 [100%] [0.00dB] [on]
  Front Right: Playback 23 [100%] [0.00dB] [on]
Simple mixer control 'Mic',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 23
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [off]
  Front Right: Playback 0 [0%] [-34.50dB] [off]
Simple mixer control 'Mic Boost',0
  Capabilities: volume
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 3 [100%]
  Front Right: 3 [100%]
Simple mixer control 'Beep',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
  Playback channels: Mono
  Limits: Playback 0 - 15
  Mono: Playback 5 [33%] [-30.00dB] [off]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 54
  Front Left: Capture 47 [87%] [12.00dB] [on]
  Front Right: Capture 47 [87%] [12.00dB] [on]
Simple mixer control 'Capture',1
  Capabilities: cvolume cswitch
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 54
  Front Left: Capture 0 [0%] [-58.50dB] [off]
  Front Right: Capture 0 [0%] [-58.50dB] [off]
Simple mixer control 'Digital',0
  Capabilities: cvolume
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 120
  Front Left: Capture 96 [80%] [18.00dB]
  Front Right: Capture 96 [80%] [18.00dB]
Simple mixer control 'Dock',0
  Capabilities: pswitch
  Playback channels: Front Left - Front Right
  Mono:
  Front Left: Playback [off]
  Front Right: Playback [off]
Simple mixer control 'Dock Mic',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 23
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [off]
  Front Right: Playback 0 [0%] [-34.50dB] [off]
Simple mixer control 'Dock Mic Boost',0
  Capabilities: volume
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 0 [0%]
  Front Right: 0 [0%]
Simple mixer control 'Input Source',0
  Capabilities: cenum
  Items: 'Mic' 'Internal Mic' 'Dock Mic' 'Mix'
  Item0: 'Internal Mic'
Simple mixer control 'Input Source',1
  Capabilities: cenum
  Items: 'Mic' 'Internal Mic' 'Dock Mic' 'Mix'
  Item0: 'Mic'
Simple mixer control 'Internal Mic',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 23
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [off]
  Front Right: Playback 0 [0%] [-34.50dB] [off]
Simple mixer control 'Internal Mic Boost',0
  Capabilities: volume
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 0 [0%]
  Front Right: 0 [0%]


!!Alsactl output
!!-------------

--startcollapse--
state.Intel {
	control.1 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'Master Playback Volume'
		value.0 24
		value.1 24
	}
	control.2 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Master Playback Switch'
		value.0 true
		value.1 true
	}
	control.3 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Dock Playback Switch'
		value.0 false
		value.1 false
	}
	control.4 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 23'
		comment.dbmin -3450
		comment.dbmax 0
		iface MIXER
		name 'PCM Playback Volume'
		value.0 23
		value.1 23
	}
	control.5 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'PCM Playback Switch'
		value.0 true
		value.1 true
	}
	control.6 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 23'
		comment.dbmin -3450
		comment.dbmax 0
		iface MIXER
		name 'Mic Playback Volume'
		value.0 0
		value.1 0
	}
	control.7 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Mic Playback Switch'
		value.0 false
		value.1 false
	}
	control.8 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 23'
		comment.dbmin -3450
		comment.dbmax 0
		iface MIXER
		name 'Internal Mic Playback Volume'
		value.0 0
		value.1 0
	}
	control.9 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Internal Mic Playback Switch'
		value.0 false
		value.1 false
	}
	control.10 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 23'
		comment.dbmin -3450
		comment.dbmax 0
		iface MIXER
		name 'Dock Mic Playback Volume'
		value.0 0
		value.1 0
	}
	control.11 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Dock Mic Playback Switch'
		value.0 false
		value.1 false
	}
	control.12 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Mic Boost'
		value.0 3
		value.1 3
	}
	control.13 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Internal Mic Boost'
		value.0 0
		value.1 0
	}
	control.14 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Dock Mic Boost'
		value.0 0
		value.1 0
	}
	control.15 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 54'
		comment.dbmin -5850
		comment.dbmax 2250
		iface MIXER
		name 'Capture Volume'
		value.0 47
		value.1 47
	}
	control.16 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		value.0 true
		value.1 true
	}
	control.17 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 54'
		comment.dbmin -5850
		comment.dbmax 2250
		iface MIXER
		name 'Capture Volume'
		index 1
		value.0 0
		value.1 0
	}
	control.18 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 1
		value.0 false
		value.1 false
	}
	control.19 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Mic
		comment.item.1 'Internal Mic'
		comment.item.2 'Dock Mic'
		comment.item.3 Mix
		iface MIXER
		name 'Input Source'
		value 'Internal Mic'
	}
	control.20 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Mic
		comment.item.1 'Internal Mic'
		comment.item.2 'Dock Mic'
		comment.item.3 Mix
		iface MIXER
		name 'Input Source'
		index 1
		value Mic
	}
	control.21 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 15'
		comment.dbmin -4500
		comment.dbmax 0
		iface MIXER
		name 'Beep Playback Volume'
		value 5
	}
	control.22 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Beep Playback Switch'
		value false
	}
	control.23 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 120'
		comment.tlv '0000000100000008fffff44800000032'
		comment.dbmin -3000
		comment.dbmax 3000
		iface MIXER
		name 'Digital Capture Volume'
		value.0 96
		value.1 96
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
fbcon
font
bitblit
softcursor
af_packet
i915
fb
binfmt_misc
drm
i2c_algo_bit
cfbcopyarea
video
backlight
output
i2c_core
cfbimgblt
cfbfillrect
sco
bridge
stp
bnep
rfcomm
l2cap
kvm_intel
kvm
ipv6
acpi_cpufreq
cpufreq_powersave
cpufreq_userspace
cpufreq_stats
cpufreq_conservative
fuse
snd_hda_codec_analog
uvcvideo
arc4
btusb
snd_hda_intel
bluetooth
ecb
videodev
snd_hda_codec
v4l1_compat
qcserial
v4l2_compat_ioctl32
iwlagn
sdhci_pci
snd_hwdep
iwlcore
sdhci
snd_pcm_oss
rfkill
usbserial
snd_mixer_oss
mac80211
mmc_core
uhci_hcd
ohci1394
snd_pcm
hp_accel
snd_timer
ehci_hcd
lis3lv02d
ricoh_mmc
psmouse
snd_page_alloc
cfg80211
ieee1394
e1000e
usbcore
intel_agp
led_class
battery
pcspkr
serio_raw
evdev
ac
button


!!ALSA/HDA dmesg
!!------------------

Advanced Linux Sound Architecture Driver Version 1.0.20.
ALSA device list:
  No soundcards found.
PM: Adding info for serio:serio3
--
PM: Adding info for No Bus:usbdev4.2_ep00
HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: irq 30 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
Bluetooth: Generic Bluetooth USB driver ver 0.5
--
PM: Adding info for No Bus:input9
input: HDA Digital PCBeep
as /devices/pci0000:00/0000:00:1b.0/input/input9
PM: Adding info for No Bus:event9

====== alsa-info output on 2.6.32-rc6 =====

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.58
!!################################

!!Script ran on: Tue Nov 10 18:51:20 UTC 2009


!!Linux Distribution
!!------------------

Debian GNU/Linux squeeze/sid \n \l


!!DMI Information
!!---------------

Manufacturer:      Hewlett-Packard
Product Name:      HP EliteBook 2530p


!!Kernel Information
!!------------------

Kernel release:    2.6.32-rc6-64
Operating System:  GNU/Linux
Architecture:      x86_64
Processor:         unknown
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.21
Library version:    1.0.21a
Utilities version:  1.0.21


!!Loaded ALSA modules
!!-------------------



!!Sound Servers on this system
!!----------------------------

aRts:
      Installed - Yes (/usr/bin/artsd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xd4820000 irq 30


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 03)


!!Advanced information - PCI Vendor/Device/Susbsystem ID's
!!--------------------------------------------------------

00:1b.0 0403: 8086:293e (rev 03)
	Subsystem: 103c:30e1


!!Modprobe options (Sound related)
!!--------------------------------

snd-atiixp-modem: index=-2
snd-intel8x0m: index=-2
snd-via82xx-modem: index=-2
snd-pcsp: index=-2
snd-hda-intel: enable_msi=1
snd-hda-intel: single_cmd=1
snd-hda-intel: model=laptop


!!Loaded sound module options
!!--------------------------


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: Analog Devices AD1984A
Address: 0
Function Id: 0x1
Vendor Id: 0x11d4194a
Subsystem Id: 0x103c30e1
Revision Id: 0x100400
No Modem Function Group found
Default PCM:
    rates [0x7ff]: 8000 11025 16000 22050 32000 44100 48000 88200 96000
176400 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
Default Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
GPIO: io=3, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=1, unsol=0
  IO[1]: enable=1, dir=1, wake=0, sticky=0, data=0, unsol=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0x30211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 3 samples
Node 0x03 [Audio Output] wcaps 0x405: Stereo Amp-Out
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
  Amp-Out vals:  [0x27 0x27]
  Converter: stream=0, channel=0
  Power: setting=D0, actual=D3
Node 0x04 [Audio Output] wcaps 0x405: Stereo Amp-Out
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
  Amp-Out vals:  [0x27 0x27]
  Converter: stream=0, channel=0
  Power: setting=D0, actual=D3
Node 0x05 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x06 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x07 [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x00 0x00]
  Connection: 2
     0x22 0x21
Node 0x08 [Audio Input] wcaps 0x100501: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  Power: setting=D0, actual=D3
  Connection: 1
     0x0c
Node 0x09 [Audio Input] wcaps 0x100501: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  Power: setting=D0, actual=D3
  Connection: 1
     0x0d
Node 0x0a [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x00 0x00]
  Connection: 2
     0x04 0x21
Node 0x0b [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x00 0x00]
  Connection: 2
     0x0f 0x21
Node 0x0c [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x27, nsteps=0x36, stepsize=0x05, mute=1
  Amp-Out vals:  [0x2f 0x2f]
  Connection: 6
     0x14 0x15* 0x16 0x20 0x25 0x17
Node 0x0d [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x27, nsteps=0x36, stepsize=0x05, mute=1
  Amp-Out vals:  [0x80 0x80]
  Connection: 6
     0x14* 0x15 0x16 0x20 0x25 0x17
Node 0x0e [Audio Selector] wcaps 0x300101: Stereo
  Connection: 2
     0x03* 0x04
Node 0x0f [Audio Selector] wcaps 0x300101: Stereo
  Connection: 2
     0x03* 0x04
Node 0x10 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Amp-Out caps: ofs=0x0f, nsteps=0x0f, stepsize=0x0b, mute=1
  Amp-Out vals:  [0x00]
Node 0x11 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000001f: OUT HP Detect Trigger ImpSense
  Pin Default 0x04212040: [Jack] HP Out at Ext Right
    Conn = 1/8, Color = Grey
    DefAssociation = 0x4, Sequence = 0x0
  Pin-ctls: 0xc0: OUT HP
  Unsolicited: tag=37, enabled=1
  Connection: 1
     0x07
Node 0x12 [Pin Complex] wcaps 0x40058d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0001001f: OUT HP EAPD Detect Trigger ImpSense
  EAPD 0x0:
  Pin Default 0x01014010: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Green
    DefAssociation = 0x1, Sequence = 0x0
  Pin-ctls: 0xc0: OUT HP
  Unsolicited: tag=37, enabled=1
  Power: setting=D0, actual=D0
  Connection: 1
     0x0a
Node 0x13 [Pin Complex] wcaps 0x40050c: Mono Amp-Out
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x00]
  Pincap 0x00010010: OUT EAPD
  EAPD 0x0:
  Pin Default 0x413711f0: [N/A] CD at Ext Rear
    Conn = Analog, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Power: setting=D0, actual=D0
  Connection: 1
     0x1f
Node 0x14 [Pin Complex] wcaps 0x40008b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x03 0x03]
  Pincap 0x00003727: IN Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x04a12060: [Jack] Mic at Ext Right
    Conn = 1/8, Color = Grey
    DefAssociation = 0x6, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=36, enabled=1
Node 0x15 [Pin Complex] wcaps 0x40008b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Pincap 0x00003727: IN Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x91a7112e: [Fixed] Mic at Int Rear
    Conn = Analog, Color = Black
    DefAssociation = 0x2, Sequence = 0xe
    Misc = NO_PRESENCE
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
Node 0x16 [Pin Complex] wcaps 0x40058d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x00010037: IN OUT EAPD Detect Trigger ImpSense
  EAPD 0x2: EAPD
  Pin Default 0x9217411f: [Fixed] Speaker at Int Front
    Conn = Analog, Color = Green
    DefAssociation = 0x1, Sequence = 0xf
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Power: setting=D0, actual=D0
  Connection: 1
     0x0b
Node 0x17 [Pin Complex] wcaps 0x40020b: Stereo Digital Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x17, mute=0
  Amp-In vals:  [0x00 0x00]
  Pincap 0x00000020: IN
  Pin Default 0x41a6e130: [N/A] Mic at Ext Rear
    Conn = Digital, Color = White
    DefAssociation = 0x3, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
Node 0x18 [Vendor Defined Widget] wcaps 0xf00100: Mono
  Connection: 1
     0x06
Node 0x19 [Power Widget] wcaps 0x500500: Mono
  Power: setting=D0, actual=D0
  Connection: 2
     0x20 0x21
Node 0x1a [Pin Complex] wcaps 0x400000: Mono
  Pincap 0x00000020: IN
  Pin Default 0x90f711f0: [Fixed] Other at Int N/A
    Conn = Analog, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x1b [Pin Complex] wcaps 0x40038d: Stereo Digital Amp-Out
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=1
  Amp-Out vals:  [0x27 0x27]
  Pincap 0x00000014: OUT Detect
  Pin Default 0x41561150: [N/A] Digital Out at Ext Rear
    Conn = Digital, Color = Black
    DefAssociation = 0x5, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x02
Node 0x1c [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x00003737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x01813021: [Jack] Line In at Ext Rear
    Conn = 1/8, Color = Blue
    DefAssociation = 0x2, Sequence = 0x1
  Pin-ctls: 0x40: OUT VREF_HIZ
  Unsolicited: tag=36, enabled=1
  Connection: 1
     0x24
Node 0x1d [Vendor Defined Widget] wcaps 0xf00100: Mono
  Connection: 25
     0x07* 0x0a 0x0b 0x0c 0x0d 0x0e 0x0f 0x11 0x12 0x13 0x14 0x15 0x16
0x19 0x1a 0x1c 0x1e 0x1f 0x20 0x21 0x22 0x23 0x24 0x25 0x26
Node 0x1e [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x00 0x00]
  Connection: 2
     0x0e 0x21
Node 0x1f [Audio Mixer] wcaps 0x200100: Mono
  Connection: 1
     0x1e
Node 0x20 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80
0x80] [0x17 0x17] [0x97 0x97]
  Connection: 7
     0x14 0x15 0x16 0x1a 0x25 0x03 0x04
Node 0x21 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x18 0x18]
  Connection: 1
     0x20
Node 0x22 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 2
     0x03* 0x04
Node 0x23 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 2
     0x03* 0x04
Node 0x24 [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80]
  Connection: 2
     0x23 0x21
Node 0x25 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 1
     0x1c
Node 0x26 [Vendor Defined Widget] wcaps 0xf00100: Mono
  Connection: 3
     0x14* 0x15 0x1c
Node 0x27 [Vendor Defined Widget] wcaps 0xf00301: Stereo Digital
  Connection: 2
     0x08* 0x09
Node 0x28 [Vendor Defined Widget] wcaps 0xf0030d: Stereo Digital Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Connection: 2
     0x08* 0x09
Node 0x29 [Vendor Defined Widget] wcaps 0xf0030d: Stereo Digital Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Connection: 2
     0x08* 0x09
Node 0x2a [Vendor Defined Widget] wcaps 0xf00301: Stereo Digital
  Connection: 2
     0x01* 0x27
Codec: LSI ID 1040
Address: 1
Function Id: 0x2
Vendor Id: 0x11c11040
Subsystem Id: 0x103c1378
Revision Id: 0x100200
Modem Function Group: 0x1
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw---- 1 root audio 116,  0 Nov 10 13:32 /dev/snd/controlC0
crw-rw---- 1 root audio 116,  4 Nov 10 13:32 /dev/snd/hwC0D0
crw-rw---- 1 root audio 116,  5 Nov 10 13:32 /dev/snd/hwC0D1
crw-rw---- 1 root audio 116, 24 Nov 10 13:32 /dev/snd/pcmC0D0c
crw-rw---- 1 root audio 116, 16 Nov 10 13:32 /dev/snd/pcmC0D0p
crw-rw---- 1 root audio 116, 33 Nov 10 13:32 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root  60 Nov 10 13:32 .
drwxr-xr-x 3 root root 180 Nov 10 13:32 ..
lrwxrwxrwx 1 root root  12 Nov 10 13:32 pci-0000:00:1b.0 -> ../controlC0


!!ALSA configuration files
!!------------------------

!!User specific config file (~/.asoundrc)

              pcm.copy {
                type plug
                slave {
                  pcm hw
                }
                route_policy copy
              }



!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: AD198x Analog [AD198x Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: AD198x Analog [AD198x Analog]
  Subdevices: 2/2
  Subdevice #0: subdevice #0
  Subdevice #1: subdevice #1

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0xd4820000 irq 30'
  Mixer name	: 'Analog Devices AD1984A'
  Components	: 'HDA:11d4194a,103c30e1,00100400
HDA:11c11040,103c1378,00100200'
  Controls      : 19
  Simple ctrls  : 12
Simple mixer control 'Master',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 24 [77%] [-10.50dB] [on]
  Front Right: Playback 24 [77%] [-10.50dB] [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 23
  Mono:
  Front Left: Playback 23 [100%] [0.00dB] [on]
  Front Right: Playback 23 [100%] [0.00dB] [on]
Simple mixer control 'Mic',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 23
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [off]
  Front Right: Playback 0 [0%] [-34.50dB] [off]
Simple mixer control 'Mic Boost',0
  Capabilities: volume
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 3 [100%]
  Front Right: 3 [100%]
Simple mixer control 'Beep',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
  Playback channels: Mono
  Limits: Playback 0 - 15
  Mono: Playback 5 [33%] [-30.00dB] [off]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 54
  Front Left: Capture 47 [87%] [12.00dB] [on]
  Front Right: Capture 47 [87%] [12.00dB] [on]
Simple mixer control 'Digital',0
  Capabilities: cvolume
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 120
  Front Left: Capture 96 [80%] [18.00dB]
  Front Right: Capture 96 [80%] [18.00dB]
Simple mixer control 'Dock',0
  Capabilities: pswitch
  Playback channels: Front Left - Front Right
  Mono:
  Front Left: Playback [off]
  Front Right: Playback [off]
Simple mixer control 'Dock Mic',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 23
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [off]
  Front Right: Playback 0 [0%] [-34.50dB] [off]
Simple mixer control 'Dock Mic Boost',0
  Capabilities: volume
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 0 [0%]
  Front Right: 0 [0%]
Simple mixer control 'Internal Mic',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 23
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [off]
  Front Right: Playback 0 [0%] [-34.50dB] [off]
Simple mixer control 'Internal Mic Boost',0
  Capabilities: volume
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 0 [0%]
  Front Right: 0 [0%]


!!Alsactl output
!!-------------

--startcollapse--
state.Intel {
	control.1 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'Master Playback Volume'
		value.0 24
		value.1 24
	}
	control.2 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Master Playback Switch'
		value.0 true
		value.1 true
	}
	control.3 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Dock Playback Switch'
		value.0 false
		value.1 false
	}
	control.4 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 23'
		comment.dbmin -3450
		comment.dbmax 0
		iface MIXER
		name 'PCM Playback Volume'
		value.0 23
		value.1 23
	}
	control.5 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'PCM Playback Switch'
		value.0 true
		value.1 true
	}
	control.6 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 23'
		comment.dbmin -3450
		comment.dbmax 0
		iface MIXER
		name 'Mic Playback Volume'
		value.0 0
		value.1 0
	}
	control.7 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Mic Playback Switch'
		value.0 false
		value.1 false
	}
	control.8 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 23'
		comment.dbmin -3450
		comment.dbmax 0
		iface MIXER
		name 'Internal Mic Playback Volume'
		value.0 0
		value.1 0
	}
	control.9 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Internal Mic Playback Switch'
		value.0 false
		value.1 false
	}
	control.10 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 23'
		comment.dbmin -3450
		comment.dbmax 0
		iface MIXER
		name 'Dock Mic Playback Volume'
		value.0 0
		value.1 0
	}
	control.11 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Dock Mic Playback Switch'
		value.0 false
		value.1 false
	}
	control.12 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Mic Boost'
		value.0 3
		value.1 3
	}
	control.13 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Internal Mic Boost'
		value.0 0
		value.1 0
	}
	control.14 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Dock Mic Boost'
		value.0 0
		value.1 0
	}
	control.15 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 54'
		comment.dbmin -5850
		comment.dbmax 2250
		iface MIXER
		name 'Capture Volume'
		value.0 47
		value.1 47
	}
	control.16 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		value.0 true
		value.1 true
	}
	control.17 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 15'
		comment.dbmin -4500
		comment.dbmax 0
		iface MIXER
		name 'Beep Playback Volume'
		value 5
	}
	control.18 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Beep Playback Switch'
		value false
	}
	control.19 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 120'
		comment.tlv '0000000100000008fffff44800000032'
		comment.dbmin -3000
		comment.dbmax 3000
		iface MIXER
		name 'Digital Capture Volume'
		value.0 96
		value.1 96
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
xt_tcpudp
iptable_nat
nf_nat
nf_conntrack_ipv4
nf_conntrack
nf_defrag_ipv4
ip_tables
x_tables
fbcon
font
af_packet
bitblit
softcursor
binfmt_misc
i915
drm_kms_helper
drm
fb
i2c_algo_bit
cfbcopyarea
i2c_core
video
backlight
output
cfbimgblt
cfbfillrect
sco
bridge
stp
bnep
rfcomm
l2cap
kvm_intel
kvm
ipv6
acpi_cpufreq
cpufreq_powersave
cpufreq_userspace
cpufreq_stats
cpufreq_conservative
fuse
snd_hda_codec_analog
btusb
bluetooth
arc4
snd_hda_intel
ecb
qcserial
snd_hda_codec
iwlagn
snd_hwdep
iwlcore
snd_pcm_oss
usbserial
mac80211
snd_mixer_oss
sdhci_pci
snd_pcm
sdhci
cfg80211
uhci_hcd
hp_accel
snd_timer
ehci_hcd
lis3lv02d
psmouse
ohci1394
mmc_core
ricoh_mmc
e1000e
rfkill
usbcore
snd_page_alloc
intel_agp
ieee1394
input_polldev
serio_raw
pcspkr
ac
battery
evdev
led_class
button


!!Sysfs Files
!!-----------

/sys/class/sound/hwC0D0/init_pin_configs:
0x11 0x04212040
0x12 0x01014010
0x13 0x413711f0
0x14 0x04a12060
0x15 0x91a7112e
0x16 0x9217411f
0x17 0x41a6e130
0x1a 0x90f711f0
0x1b 0x41561150
0x1c 0x01813021

/sys/class/sound/hwC0D0/driver_pin_configs:

/sys/class/sound/hwC0D0/user_pin_configs:

/sys/class/sound/hwC0D0/init_verbs:

/sys/class/sound/hwC0D1/init_pin_configs:

/sys/class/sound/hwC0D1/driver_pin_configs:

/sys/class/sound/hwC0D1/user_pin_configs:

/sys/class/sound/hwC0D1/init_verbs:


!!ALSA/HDA dmesg
!!------------------

Advanced Linux Sound Architecture Driver Version 1.0.21.
ALSA device list:
  No soundcards found.
TCP cubic registered
--
PM: Adding info for No Bus:wlan0
HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: irq 30 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
PM: Adding info for ieee1394:5566778811223344
--
PM: Adding info for No Bus:input7
input: HDA Digital PCBeep
as /devices/pci0000:00/0000:00:1b.0/input/input7
PM: Adding info for No Bus:event7


