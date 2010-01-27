Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787Ab0A0RRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab0A0RRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 12:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744Ab0A0RRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 12:17:20 -0500
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:44282 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214Ab0A0RRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 12:17:17 -0500
Message-ID: <4B607510.6020204@blueyonder.co.uk>
Date: Wed, 27 Jan 2010 17:17:04 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.14 Thunderbird/3.0 ThunderBrowse/3.2.7
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: HDA Intel Audio hang on boot
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>	<201001261922.35213.rjw@sisk.pl>	<4B5F5777.8070701@blueyonder.co.uk>	<201001270156.46217.rjw@sisk.pl>	<4B5FA785.3010002@blueyonder.co.uk> <s5hljfk82wn.wl%tiwai@suse.de>
In-Reply-To: <s5hljfk82wn.wl%tiwai@suse.de>
Content-Type: multipart/mixed;
 boundary="------------050108090109080306090504"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050108090109080306090504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 27/01/10 06:42, Takashi Iwai wrote:
> At Wed, 27 Jan 2010 02:40:05 +0000,
> Sid Boyce wrote:
>>
>> On 27/01/10 00:56, Rafael J. Wysocki wrote:
>>> On Tuesday 26 January 2010, Sid Boyce wrote:
>>>> I forgot to mention 2.6.33-rc5 now boots successfully.
>>>
>>> Does that mean the problem is fixed in 2.6.33-rc5 or you still need the
>>> enable_msi=0 workaround?
>>>
>>> Rafael
>>>
>> It boots only with the enable_msi=0 workaround.
> 
> OK, then could you run alsa-info.sh (with --no-upload option), and
> attach the generated file?  I'll add your device to the blacklist for
> disabling MSI in hda_intel.c.
> 
> 
> thanks,
> 
> Takashi
> 
> 

Thanks.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

--------------050108090109080306090504
Content-Type: text/plain;
 name="alsa-info.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="alsa-info.txt"

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.58
!!################################

!!Script ran on: Wed Jan 27 17:10:57 UTC 2010


!!Linux Distribution
!!------------------

Welcome to openSUSE 11.3 "Teal" Milestone 0 - Kernel \r (\l). openSUSE 11.3 Milestone 0 (x86_64) LSB_VERSION="core-2.0-noarch:core-3.2-noarch:core-4.0-noarch:core-2.0-x86_64:core-3.2-x86_64:core-4.0-x86_64"


!!DMI Information
!!---------------

Manufacturer:      System manufacturer
Product Name:      System Product Name


!!Kernel Information
!!------------------

Kernel release:    2.6.33-rc5-git2-smp
Operating System:  GNU/Linux
Architecture:      x86_64
Processor:         x86_64
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.21
Library version:    1.0.22
Utilities version:  1.0.22


!!Loaded ALSA modules
!!-------------------

snd_hda_intel
snd_emu10k1
snd_usb_audio


!!Sound Servers on this system
!!----------------------------

Pulseaudio:
      Installed - Yes (/usr/bin/pulseaudio)
      Running - Yes

ESound Daemon:
      Installed - Yes (/usr/bin/esd)
      Running - No

Jack:
      Installed - Yes (/usr/local/bin/jackd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [NVidia         ]: HDA-Intel - HDA NVidia
                      HDA NVidia at 0xfe020000 irq 30
 1 [EMU0404        ]: Audigy2 - E-mu 0404b PCI [MAEM8852]
                      E-mu 0404b PCI [MAEM8852] (rev.0, serial:0x40021102) at 0xec00, irq 16
 2 [USB            ]: USB-Audio - E-MU 0404 | USB
                      E-MU Systems, Inc. E-MU 0404 | USB at usb-0000:00:04.1-1.3, high speed


!!PCI Soundcards installed in the system
!!--------------------------------------

00:07.0 Audio device: nVidia Corporation MCP72XE/MCP72P/MCP78U/MCP78S High Definition Audio (rev a1)
01:08.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
01:09.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
01:09.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)


!!Advanced information - PCI Vendor/Device/Susbsystem ID's
!!--------------------------------------------------------

00:07.0 0403: 10de:0774 (rev a1)
	Subsystem: 1043:829c
--
01:08.0 0401: 1102:0008
	Subsystem: 1102:4002


!!Loaded sound module options
!!--------------------------

!!Module: snd_hda_intel
	bdl_pos_adj : 32,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	beep_mode : 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	enable_msi : -1
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	model : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	patch : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	position_fix : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	power_save : 0
	power_save_controller : Y
	probe_mask : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	probe_only : N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N
	single_cmd : N

!!Module: snd_emu10k1
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	enable_ir : N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N
	extin : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	extout : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	max_buffer_size : 128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128
	max_synth_voices : 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
	seq_ports : 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	subsystem : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

!!Module: snd_usb_audio
	async_unlink : Y
	device_setup : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	ignore_ctl_error : N
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	nrpacks : 8
	pid : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	vid : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: Analog Devices AD1988B
Address: 0
Function Id: 0x1
Vendor Id: 0x11d4198b
Subsystem Id: 0x1043829c
Revision Id: 0x100400
No Modem Function Group found
Default PCM:
    rates [0x7ff]: 8000 11025 16000 22050 32000 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
Default Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
GPIO: io=2, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=1, unsol=0
Node 0x02 [Audio Output] wcaps 0x30311: Stereo Digital
  Control: name="IEC958 Playback Con Mask", index=0, device=0
  Control: name="IEC958 Playback Pro Mask", index=0, device=0
  Control: name="IEC958 Playback Default", index=0, device=0
  Control: name="IEC958 Playback Switch", index=0, device=0
  Control: name="IEC958 Default PCM Playback Switch", index=0, device=0
  Device: name="AD198x Digital", type="SPDIF", device=1
  Converter: stream=5, channel=0
  Digital: Enabled
  Digital category: 0x0
  PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 3 samples
  Connection: 1
     0x1d
Node 0x03 [Audio Output] wcaps 0x405: Stereo Amp-Out
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
  Amp-Out vals:  [0x27 0x27]
  Converter: stream=0, channel=0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
Node 0x04 [Audio Output] wcaps 0x405: Stereo Amp-Out
  Control: name="Front Playback Volume", index=0, device=0
  Device: name="AD198x Analog", type="Audio", device=0
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
  Amp-Out vals:  [0x26 0x26]
  Converter: stream=5, channel=0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
Node 0x05 [Audio Output] wcaps 0x405: Stereo Amp-Out
  Control: name="Center Playback Volume", index=0, device=0
  Control: name="LFE Playback Volume", index=0, device=0
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
  Amp-Out vals:  [0x26 0x26]
  Converter: stream=5, channel=0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
Node 0x06 [Audio Output] wcaps 0x405: Stereo Amp-Out
  Control: name="Surround Playback Volume", index=0, device=0
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
  Amp-Out vals:  [0x26 0x26]
  Converter: stream=5, channel=0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
Node 0x07 [Audio Input] wcaps 0x130391: Stereo Digital
  Converter: stream=0, channel=0
  SDI-Select: 0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Unsolicited: tag=00, enabled=0
  Delay: 3 samples
  Connection: 1
     0x1c
Node 0x08 [Audio Input] wcaps 0x100501: Stereo
  Device: name="AD198x Analog", type="Audio", device=0
  Converter: stream=1, channel=0
  SDI-Select: 0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
  Connection: 1
     0x0c
Node 0x09 [Audio Input] wcaps 0x100501: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
  Connection: 1
     0x0d
Node 0x0a [Audio Output] wcaps 0x405: Stereo Amp-Out
  Control: name="Side Playback Volume", index=0, device=0
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
  Amp-Out vals:  [0x26 0x26]
  Converter: stream=5, channel=0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
Node 0x0b [Audio Selector] wcaps 0x300301: Stereo Digital
  Connection: 3
     0x08* 0x09 0x0f
Node 0x0c [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Capture Volume", index=0, device=0
  Control: name="Capture Switch", index=0, device=0
  Amp-Out caps: ofs=0x27, nsteps=0x36, stepsize=0x05, mute=1
  Amp-Out vals:  [0x36 0x36]
  Connection: 10
     0x38 0x39* 0x3a 0x3b 0x3c 0x18 0x24 0x25 0x3d 0x20
Node 0x0d [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Capture Volume", index=1, device=0
  Control: name="Capture Switch", index=1, device=0
  Amp-Out caps: ofs=0x27, nsteps=0x36, stepsize=0x05, mute=1
  Amp-Out vals:  [0xa7 0xa7]
  Connection: 10
     0x38 0x39* 0x3a 0x3b 0x3c 0x18 0x24 0x25 0x3d 0x20
Node 0x0e [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Capture Volume", index=2, device=0
  Control: name="Capture Switch", index=2, device=0
  Amp-Out caps: ofs=0x27, nsteps=0x36, stepsize=0x05, mute=1
  Amp-Out vals:  [0xa7 0xa7]
  Connection: 10
     0x38 0x39* 0x3a 0x3b 0x3c 0x18 0x24 0x25 0x3d 0x20
Node 0x0f [Audio Input] wcaps 0x100501: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
  Connection: 1
     0x0e
Node 0x10 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Control: name="Beep Playback Volume", index=0, device=0
  Control: name="Beep Playback Switch", index=0, device=0
  Amp-Out caps: ofs=0x0f, nsteps=0x0f, stepsize=0x0b, mute=1
  Amp-Out vals:  [0x00]
Node 0x11 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000373f: IN OUT HP Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x02214030: [Jack] HP Out at Ext Front
    Conn = 1/8, Color = Green
    DefAssociation = 0x3, Sequence = 0x0
  Pin-ctls: 0xc0: OUT HP VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x22
Node 0x12 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000373f: IN OUT HP Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x01014010: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Green
    DefAssociation = 0x1, Sequence = 0x0
  Pin-ctls: 0x40: OUT VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x29
Node 0x13 [Pin Complex] wcaps 0x40010c: Mono Amp-Out
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x00]
  Pincap 0x00000010: OUT
  Pin Default 0x511711f0: [N/A] Speaker at Int Rear
    Conn = Analog, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Connection: 1
     0x2d
Node 0x14 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000373f: IN OUT HP Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x02a1902e: [Jack] Mic at Ext Front
    Conn = 1/8, Color = Pink
    DefAssociation = 0x2, Sequence = 0xe
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x2b
Node 0x15 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x00003737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x01813021: [Jack] Line In at Ext Rear
    Conn = 1/8, Color = Blue
    DefAssociation = 0x2, Sequence = 0x1
  Pin-ctls: 0x20: IN VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x2c
Node 0x16 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x00003737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x01011012: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0x1, Sequence = 0x2
  Pin-ctls: 0x40: OUT VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x2a
Node 0x17 [Pin Complex] wcaps 0x40098d: Stereo Amp-Out R/L
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x00003737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x01a19020: [Jack] Mic at Ext Rear
    Conn = 1/8, Color = Pink
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x26
Node 0x18 [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x00000020: IN
  Pin Default 0x99331122: [Fixed] CD at Int ATAPI
    Conn = ATAPI, Color = Black
    DefAssociation = 0x2, Sequence = 0x2
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x19 [Power Widget] wcaps 0x500500: Mono
  Power states:  D0 D3
  Power: setting=D0, actual=D0
  Connection: 2
     0x20 0x21
Node 0x1a [Pin Complex] wcaps 0x400000: Mono
  Pincap 0x00000020: IN
  Pin Default 0x91f711f0: [Fixed] Other at Int Rear
    Conn = Analog, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x1b [Pin Complex] wcaps 0x40030d: Stereo Digital Amp-Out
  Control: name="IEC958 Playback Volume", index=0, device=0
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=1
  Amp-Out vals:  [0x26 0x26]
  Pincap 0x00000010: OUT
  Pin Default 0x0145f1f0: [Jack] SPDIF Out at Ext Rear
    Conn = Optical, Color = Other
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Connection: 1
     0x02
Node 0x1c [Pin Complex] wcaps 0x40020b: Stereo Digital Amp-In
  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x97 0x97]
  Pincap 0x00000020: IN
  Pin Default 0x41c5f1f0: [N/A] SPDIF In at Ext Rear
    Conn = Optical, Color = Other
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x1d [Audio Mixer] wcaps 0x200303: Stereo Digital Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80]
  Connection: 2
     0x01 0x0b
Node 0x1e [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80]
  Connection: 2
     0x36 0x21
Node 0x1f [Volume Knob Widget] wcaps 0x600080: Mono
  Volume-Knob: delta=1, steps=63, direct=0, val=0
  Unsolicited: tag=00, enabled=0
  Connection: 0
Node 0x20 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Control: name="Mic Playback Volume", index=0, device=0
  Control: name="Mic Playback Switch", index=0, device=0
  Control: name="Front Mic Playback Volume", index=0, device=0
  Control: name="Front Mic Playback Switch", index=0, device=0
  Control: name="Line Playback Volume", index=0, device=0
  Control: name="Line Playback Switch", index=0, device=0
  Control: name="Front Line Playback Volume", index=0, device=0
  Control: name="Front Line Playback Switch", index=0, device=0
  Control: name="CD Playback Volume", index=0, device=0
  Control: name="CD Playback Switch", index=0, device=0
  Control: name="Aux Playback Volume", index=0, device=0
  Control: name="Aux Playback Switch", index=0, device=0
  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x1f 0x1f] [0x0b 0x0b] [0x1f 0x1f] [0x80 0x80] [0x0c 0x0c] [0x80 0x80] [0x1f 0x1f] [0x80 0x80]
  Connection: 8
     0x39 0x33 0x38 0x3d 0x34 0x3b 0x18 0x1a
Node 0x21 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Analog Mix Playback Volume", index=0, device=0
  Control: name="Analog Mix Playback Switch", index=0, device=0
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x1f 0x1f]
  Connection: 1
     0x20
Node 0x22 [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Control: name="Headphone Playback Switch", index=0, device=0
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x37 0x21
Node 0x23 [Vendor Defined Widget] wcaps 0xf00100: Mono
  Connection: 18
     0x11* 0x12 0x13 0x14 0x15 0x16 0x17 0x18 0x24 0x25 0x38 0x39 0x3a 0x3b 0x3c 0x3d 0x20 0x21
Node 0x24 [Pin Complex] wcaps 0x40098d: Stereo Amp-Out R/L
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x00000037: IN OUT Detect Trigger ImpSense
  Pin Default 0x01016011: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Orange
    DefAssociation = 0x1, Sequence = 0x1
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x27
Node 0x25 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x00000037: IN OUT Detect Trigger ImpSense
  Pin Default 0x01012014: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Grey
    DefAssociation = 0x1, Sequence = 0x4
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x28
Node 0x26 [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80]
  Connection: 2
     0x32 0x21
Node 0x27 [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Control: name="Center Playback Switch", index=0, device=0
  Control: name="LFE Playback Switch", index=0, device=0
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x05 0x21
Node 0x28 [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Control: name="Side Playback Switch", index=0, device=0
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x0a 0x21
Node 0x29 [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Control: name="Front Playback Switch", index=0, device=0
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x04 0x21
Node 0x2a [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Control: name="Surround Playback Switch", index=0, device=0
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x06 0x21
Node 0x2b [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80]
  Connection: 2
     0x30 0x21
Node 0x2c [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80]
  Connection: 2
     0x31 0x21
Node 0x2d [Audio Mixer] wcaps 0x200100: Mono
  Connection: 1
     0x1e
Node 0x2e [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x2f [Vendor Defined Widget] wcaps 0xf00100: Mono
  Connection: 6
     0x11* 0x12 0x14 0x15 0x16 0x17
Node 0x30 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 3
     0x03* 0x04 0x06
Node 0x31 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 2
     0x04* 0x0a
Node 0x32 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 2
     0x05* 0x04
Node 0x33 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 3
     0x3a* 0x25 0x24
Node 0x34 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 3
     0x3c* 0x25 0x24
Node 0x35 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x36 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 3
     0x03 0x04* 0x06
Node 0x37 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 3
     0x03 0x04* 0x06
Node 0x38 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 1
     0x11
Node 0x39 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Front Mic Boost", index=0, device=0
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x01 0x01]
  Connection: 1
     0x14
Node 0x3a [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 1
     0x15
Node 0x3b [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 1
     0x16
Node 0x3c [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Mic Boost", index=0, device=0
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x01 0x01]
  Connection: 1
     0x17
Node 0x3d [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 1
     0x12
Codec: Nvidia MCP78 HDMI
Address: 3
Function Id: 0x1
Vendor Id: 0x10de0002
Subsystem Id: 0x10de0101
Revision Id: 0x100000
No Modem Function Group found
Default PCM:
    rates [0x0]:
    bits [0x0]:
    formats [0x0]:
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=0, o=0, i=0, unsolicited=0, wake=0
Node 0x04 [Audio Output] wcaps 0x211: Stereo Digital
  Control: name="IEC958 Playback Con Mask", index=1, device=0
  Control: name="IEC958 Playback Pro Mask", index=1, device=0
  Control: name="IEC958 Playback Default", index=1, device=0
  Control: name="IEC958 Playback Switch", index=1, device=0
  Device: name="NVIDIA HDMI", type="HDMI", device=3
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0xc0]: 48000 88200
    bits [0xf]: 8 16 20 24
    formats [0x1]: PCM
Node 0x05 [Pin Complex] wcaps 0x400381: Stereo Digital
  Pincap 0x00000014: OUT Detect
  Pin Default 0x18560110: [Jack] Digital Out at Int HDMI
    Conn = Digital, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x04
Node 0x06 [Audio Output] wcaps 0x211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0xc0]: 48000 88200
    bits [0xf]: 8 16 20 24
    formats [0x1]: PCM
Node 0x07 [Pin Complex] wcaps 0x400381: Stereo Digital
  Pincap 0x00000014: OUT Detect
  Pin Default 0x58560121: [N/A] Digital Out at Int HDMI
    Conn = Digital, Color = Unknown
    DefAssociation = 0x2, Sequence = 0x1
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x06
Node 0x08 [Audio Output] wcaps 0x211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0xc0]: 48000 88200
    bits [0xf]: 8 16 20 24
    formats [0x1]: PCM
Node 0x09 [Pin Complex] wcaps 0x400381: Stereo Digital
  Pincap 0x00000014: OUT Detect
  Pin Default 0x58560122: [N/A] Digital Out at Int HDMI
    Conn = Digital, Color = Unknown
    DefAssociation = 0x2, Sequence = 0x2
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x08
Node 0x0a [Audio Output] wcaps 0x211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0xc0]: 48000 88200
    bits [0xf]: 8 16 20 24
    formats [0x1]: PCM
Node 0x0b [Pin Complex] wcaps 0x400381: Stereo Digital
  Pincap 0x00000014: OUT Detect
  Pin Default 0x58560123: [N/A] Digital Out at Int HDMI
    Conn = Digital, Color = Unknown
    DefAssociation = 0x2, Sequence = 0x3
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x0a
Node 0x0c [Audio Output] wcaps 0x211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0xc0]: 48000 88200
    bits [0xf]: 8 16 20 24
    formats [0x1]: PCM
Node 0x0d [Pin Complex] wcaps 0x400381: Stereo Digital
  Pincap 0x00000014: OUT Detect
  Pin Default 0x58560124: [N/A] Digital Out at Int HDMI
    Conn = Digital, Color = Unknown
    DefAssociation = 0x2, Sequence = 0x4
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x0c
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw----+ 1 root audio 116, 24 Jan 27 10:34 /dev/snd/controlC0
crw-rw----+ 1 root audio 116, 17 Jan 27 10:34 /dev/snd/controlC1
crw-rw----+ 1 root audio 116,  7 Jan 27 10:34 /dev/snd/controlC2
crw-rw----+ 1 root audio 116, 23 Jan 27 10:34 /dev/snd/hwC0D0
crw-rw----+ 1 root audio 116, 22 Jan 27 10:34 /dev/snd/hwC0D3
crw-rw----+ 1 root audio 116,  8 Jan 27 10:34 /dev/snd/hwC1D0
crw-rw----+ 1 root audio 116, 26 Jan 27 10:35 /dev/snd/hwC1D2
crw-rw----+ 1 root audio 116, 10 Jan 27 10:34 /dev/snd/midiC1D0
crw-rw----+ 1 root audio 116,  9 Jan 27 10:34 /dev/snd/midiC1D1
crw-rw----+ 1 root audio 116, 27 Jan 27 10:35 /dev/snd/midiC1D2
crw-rw----+ 1 root audio 116, 28 Jan 27 10:35 /dev/snd/midiC1D3
crw-rw----+ 1 root audio 116,  3 Jan 27 10:34 /dev/snd/midiC2D0
crw-rw----+ 1 root audio 116, 21 Jan 27 11:06 /dev/snd/pcmC0D0c
crw-rw----+ 1 root audio 116, 20 Jan 27 11:06 /dev/snd/pcmC0D0p
crw-rw----+ 1 root audio 116, 19 Jan 27 10:36 /dev/snd/pcmC0D1p
crw-rw----+ 1 root audio 116, 18 Jan 27 10:36 /dev/snd/pcmC0D3p
crw-rw----+ 1 root audio 116, 16 Jan 27 10:36 /dev/snd/pcmC1D0c
crw-rw----+ 1 root audio 116, 15 Jan 27 10:36 /dev/snd/pcmC1D0p
crw-rw----+ 1 root audio 116, 14 Jan 27 10:34 /dev/snd/pcmC1D1c
crw-rw----+ 1 root audio 116, 13 Jan 27 10:34 /dev/snd/pcmC1D2c
crw-rw----+ 1 root audio 116, 12 Jan 27 10:34 /dev/snd/pcmC1D2p
crw-rw----+ 1 root audio 116, 11 Jan 27 10:34 /dev/snd/pcmC1D3p
crw-rw----+ 1 root audio 116,  6 Jan 27 11:06 /dev/snd/pcmC2D0c
crw-rw----+ 1 root audio 116,  5 Jan 27 11:06 /dev/snd/pcmC2D0p
crw-rw----+ 1 root audio 116,  4 Jan 27 10:34 /dev/snd/pcmC2D1p
crw-rw----+ 1 root audio 116, 25 Jan 27 10:35 /dev/snd/seq
crw-rw----+ 1 root audio 116,  2 Jan 27 10:34 /dev/snd/timer

/dev/snd/by-id:
total 0
drwxr-xr-x 2 root root  60 Jan 27 10:34 .
drwxr-xr-x 4 root root 620 Jan 27 10:35 ..
lrwxrwxrwx 1 root root  12 Jan 27 10:34 usb-E-MU_Systems__Inc._E-MU_0404___USB_E-MU-63-3F04-07D70A11-07BA0-STATION_2-00 -> ../controlC2

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root 100 Jan 27 10:34 .
drwxr-xr-x 4 root root 620 Jan 27 10:35 ..
lrwxrwxrwx 1 root root  12 Jan 27 10:34 pci-0000:00:04.1-usb-0:1.3:1.0 -> ../controlC2
lrwxrwxrwx 1 root root  12 Jan 27 10:34 pci-0000:00:07.0 -> ../controlC0
lrwxrwxrwx 1 root root  12 Jan 27 10:34 pci-0000:01:08.0 -> ../controlC1


!!ALSA configuration files
!!------------------------

!!User specific config file (~/.asoundrc)

defaults.pcm.rate_converter "samplerate"


!!System wide config file (/etc/asound.conf)

defaults.pcm.rate_converter "samplerate"


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: NVidia [HDA NVidia], device 0: AD198x Analog [AD198x Analog]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
card 0: NVidia [HDA NVidia], device 1: AD198x Digital [AD198x Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: NVidia [HDA NVidia], device 3: NVIDIA HDMI [NVIDIA HDMI]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: EMU0404 [E-mu 0404b PCI [MAEM8852]], device 0: emu10k1 [ADC Capture/Standard PCM Playback]
  Subdevices: 32/32
  Subdevice #0: subdevice #0
  Subdevice #1: subdevice #1
  Subdevice #2: subdevice #2
  Subdevice #3: subdevice #3
  Subdevice #4: subdevice #4
  Subdevice #5: subdevice #5
  Subdevice #6: subdevice #6
  Subdevice #7: subdevice #7
  Subdevice #8: subdevice #8
  Subdevice #9: subdevice #9
  Subdevice #10: subdevice #10
  Subdevice #11: subdevice #11
  Subdevice #12: subdevice #12
  Subdevice #13: subdevice #13
  Subdevice #14: subdevice #14
  Subdevice #15: subdevice #15
  Subdevice #16: subdevice #16
  Subdevice #17: subdevice #17
  Subdevice #18: subdevice #18
  Subdevice #19: subdevice #19
  Subdevice #20: subdevice #20
  Subdevice #21: subdevice #21
  Subdevice #22: subdevice #22
  Subdevice #23: subdevice #23
  Subdevice #24: subdevice #24
  Subdevice #25: subdevice #25
  Subdevice #26: subdevice #26
  Subdevice #27: subdevice #27
  Subdevice #28: subdevice #28
  Subdevice #29: subdevice #29
  Subdevice #30: subdevice #30
  Subdevice #31: subdevice #31
card 1: EMU0404 [E-mu 0404b PCI [MAEM8852]], device 2: emu10k1 efx [Multichannel Capture/PT Playback]
  Subdevices: 8/8
  Subdevice #0: subdevice #0
  Subdevice #1: subdevice #1
  Subdevice #2: subdevice #2
  Subdevice #3: subdevice #3
  Subdevice #4: subdevice #4
  Subdevice #5: subdevice #5
  Subdevice #6: subdevice #6
  Subdevice #7: subdevice #7
card 1: EMU0404 [E-mu 0404b PCI [MAEM8852]], device 3: emu10k1 [Multichannel Playback]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 2: USB [E-MU 0404 | USB], device 0: USB Audio [USB Audio]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
card 2: USB [E-MU 0404 | USB], device 1: USB Audio [USB Audio #1]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: NVidia [HDA NVidia], device 0: AD198x Analog [AD198x Analog]
  Subdevices: 2/3
  Subdevice #0: subdevice #0
  Subdevice #1: subdevice #1
  Subdevice #2: subdevice #2
card 1: EMU0404 [E-mu 0404b PCI [MAEM8852]], device 0: emu10k1 [ADC Capture/Standard PCM Playback]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: EMU0404 [E-mu 0404b PCI [MAEM8852]], device 1: emu10k1 mic [Mic Capture]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: EMU0404 [E-mu 0404b PCI [MAEM8852]], device 2: emu10k1 efx [Multichannel Capture/PT Playback]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 2: USB [E-MU 0404 | USB], device 0: USB Audio [USB Audio]
  Subdevices: 0/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [NVidia]

Card hw:0 'NVidia'/'HDA NVidia at 0xfe020000 irq 30'
  Mixer name	: 'Nvidia MCP78 HDMI'
  Components	: 'HDA:11d4198b,1043829c,00100400 HDA:10de0002,10de0101,00100000'
  Controls      : 52
  Simple ctrls  : 28
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 39
  Mono: Playback 38 [97%] [-1.50dB] [on]
Simple mixer control 'Headphone',0
  Capabilities: pswitch penum
  Playback channels: Front Left - Front Right
  Mono:
  Front Left: Playback [on]
  Front Right: Playback [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 255
  Mono:
  Front Left: Playback 250 [98%] [-1.00dB]
  Front Right: Playback 250 [98%] [-1.00dB]
Simple mixer control 'Front',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 39
  Mono:
  Front Left: Playback 39 [100%] [0.00dB] [on]
  Front Right: Playback 39 [100%] [0.00dB] [on]
Simple mixer control 'Front Line',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 31 [100%] [12.00dB] [on]
  Front Right: Playback 31 [100%] [12.00dB] [on]
Simple mixer control 'Front Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 31 [100%] [12.00dB] [on]
  Front Right: Playback 31 [100%] [12.00dB] [on]
Simple mixer control 'Front Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 1 [33%]
  Front Right: 1 [33%]
Simple mixer control 'Surround',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 39
  Mono:
  Front Left: Playback 39 [100%] [0.00dB] [on]
  Front Right: Playback 39 [100%] [0.00dB] [on]
Simple mixer control 'Center',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 39
  Mono: Playback 39 [100%] [0.00dB] [on]
Simple mixer control 'LFE',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 39
  Mono: Playback 39 [100%] [0.00dB] [on]
Simple mixer control 'Side',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 39
  Mono:
  Front Left: Playback 39 [100%] [0.00dB] [on]
  Front Right: Playback 39 [100%] [0.00dB] [on]
Simple mixer control 'Line',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 11 [35%] [-18.00dB] [on]
  Front Right: Playback 11 [35%] [-18.00dB] [on]
Simple mixer control 'CD',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 31 [100%] [12.00dB] [on]
  Front Right: Playback 31 [100%] [12.00dB] [on]
Simple mixer control 'Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 12 [39%] [-16.50dB] [on]
  Front Right: Playback 12 [39%] [-16.50dB] [on]
Simple mixer control 'Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 1 [33%]
  Front Right: 1 [33%]
Simple mixer control 'IEC958',0
  Capabilities: pvolume pswitch pswitch-joined penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 39
  Mono:
  Front Left: Playback 39 [100%] [0.00dB] [on]
  Front Right: Playback 39 [100%] [0.00dB] [on]
Simple mixer control 'IEC958 Default PCM',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'IEC958 Playback Source',0
  Capabilities: enum
  Items: 'PCM' 'ADC1' 'ADC2' 'ADC3'
  Item0: 'PCM'
Simple mixer control 'IEC958',1
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [off]
Simple mixer control 'Beep',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 15
  Mono: Playback 15 [100%] [0.00dB] [on]
Simple mixer control 'Aux',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 31 [100%] [12.00dB] [on]
  Front Right: Playback 31 [100%] [12.00dB] [on]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 54
  Front Left: Capture 54 [100%] [22.50dB] [on]
  Front Right: Capture 54 [100%] [22.50dB] [on]
Simple mixer control 'Capture',1
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 54
  Front Left: Capture 39 [72%] [0.00dB] [off]
  Front Right: Capture 39 [72%] [0.00dB] [off]
Simple mixer control 'Capture',2
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 54
  Front Left: Capture 39 [72%] [0.00dB] [off]
  Front Right: Capture 39 [72%] [0.00dB] [off]
Simple mixer control 'Analog Mix',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 31 [100%] [0.00dB] [on]
  Front Right: Playback 31 [100%] [0.00dB] [on]
Simple mixer control 'Input Source',0
  Capabilities: cenum
  Items: 'Mic' 'Front Mic' 'Line' 'Front Line' 'CD' 'Aux' 'Mix'
  Item0: 'Front Mic'
Simple mixer control 'Input Source',1
  Capabilities: cenum
  Items: 'Mic' 'Front Mic' 'Line' 'Front Line' 'CD' 'Aux' 'Mix'
  Item0: 'Mic'
Simple mixer control 'Input Source',2
  Capabilities: cenum
  Items: 'Mic' 'Front Mic' 'Line' 'Front Line' 'CD' 'Aux' 'Mix'
  Item0: 'Mic'

!!-------Mixer controls for card 1 [EMU0404]

Card hw:1 'EMU0404'/'E-mu 0404b PCI [MAEM8852] (rev.0, serial:0x40021102) at 0xec00, irq 16'
  Mixer name	: 'SB Audigy'
  Components	: ''
  Controls      : 239
  Simple ctrls  : 80
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 100
  Mono: Playback 99 [99%] [0.40dB]
Simple mixer control 'Tone',0
  Capabilities: pswitch penum
  Playback channels: Front Left - Front Right
  Mono:
  Front Left: Playback [off]
  Front Right: Playback [off]
Simple mixer control 'Bass',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 40
  Front Left: 20 [50%]
  Front Right: 20 [50%]
Simple mixer control 'Treble',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 40
  Front Left: 20 [50%]
  Front Right: 20 [50%]
Simple mixer control 'PCM',0
  Capabilities: pvolume cvolume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 100 Capture 0 - 100
  Front Left: Playback 100 [100%] [0.00dB] Capture 100 [100%] [0.00dB]
  Front Right: Playback 100 [100%] [0.00dB] Capture 100 [100%] [0.00dB]
Simple mixer control 'PCM Center',0
  Capabilities: pvolume pvolume-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 100
  Mono: Playback 100 [100%] [0.00dB]
Simple mixer control 'PCM Front',0
  Capabilities: pvolume penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 100
  Mono:
  Front Left: Playback 100 [100%] [0.00dB]
  Front Right: Playback 100 [100%] [0.00dB]
Simple mixer control 'PCM LFE',0
  Capabilities: pvolume pvolume-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 100
  Mono: Playback 100 [100%] [0.00dB]
Simple mixer control 'PCM Side',0
  Capabilities: pvolume penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 100
  Mono:
  Front Left: Playback 100 [100%] [0.00dB]
  Front Right: Playback 100 [100%] [0.00dB]
Simple mixer control 'PCM Surround',0
  Capabilities: pvolume penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 100
  Mono:
  Front Left: Playback 100 [100%] [0.00dB]
  Front Right: Playback 100 [100%] [0.00dB]
Simple mixer control 'Front',0
  Capabilities: pvolume penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 100
  Mono:
  Front Left: Playback 100 [100%] [0.00dB]
  Front Right: Playback 100 [100%] [0.00dB]
Simple mixer control 'Surround',0
  Capabilities: pvolume penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 100
  Mono:
  Front Left: Playback 100 [100%] [0.00dB]
  Front Right: Playback 100 [100%] [0.00dB]
Simple mixer control 'Center',0
  Capabilities: pvolume pvolume-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 100
  Mono: Playback 100 [100%] [0.00dB]
Simple mixer control 'LFE',0
  Capabilities: pvolume pvolume-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 100
  Mono: Playback 100 [100%] [0.00dB]
Simple mixer control 'Side',0
  Capabilities: pvolume penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 100
  Mono:
  Front Left: Playback 100 [100%] [0.00dB]
  Front Right: Playback 100 [100%] [0.00dB]
Simple mixer control 'Synth',0
  Capabilities: pvolume cvolume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 100 Capture 0 - 100
  Front Left: Playback 80 [80%] [-8.00dB] Capture 100 [100%] [0.00dB]
  Front Right: Playback 80 [80%] [-8.00dB] Capture 100 [100%] [0.00dB]
Simple mixer control 'DSP 0',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: '0202 ADC Left'
Simple mixer control 'DSP 1',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: '0202 ADC Right'
Simple mixer control 'DSP 10',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP 11',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP 12',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP 13',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP 14',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP 15',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP 2',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP 3',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP 4',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP 5',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP 6',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP 7',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP 8',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP 9',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP A',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP B',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP C',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP D',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP E',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'DSP F',0
  Capabilities: cenum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Silence'
Simple mixer control 'Line',0
  Capabilities: pvolume cvolume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 100 Capture 0 - 100
  Front Left: Playback 100 [100%] [0.00dB] Capture 100 [100%] [0.00dB]
  Front Right: Playback 97 [97%] [-1.20dB] Capture 100 [100%] [0.00dB]
Simple mixer control 'CD',0
  Capabilities: pvolume cvolume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 100 Capture 0 - 100
  Front Left: Playback 31 [31%] [-27.60dB] Capture 30 [30%] [-28.00dB]
  Front Right: Playback 31 [31%] [-27.60dB] Capture 30 [30%] [-28.00dB]
Simple mixer control 'Mic',0
  Capabilities: pvolume cvolume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 100 Capture 0 - 100
  Front Left: Playback 94 [94%] [-2.40dB] Capture 99 [99%] [0.40dB]
  Front Right: Playback 94 [94%] [-2.40dB] Capture 100 [100%] [0.00dB]
Simple mixer control 'IEC958 Optical',0
  Capabilities: pvolume cvolume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 100 Capture 0 - 100
  Front Left: Playback 0 [0%] [-99999.99dB] Capture 0 [0%] [-99999.99dB]
  Front Right: Playback 0 [0%] [-99999.99dB] Capture 0 [0%] [-99999.99dB]
Simple mixer control 'IEC958 Optical Raw',0
  Capabilities: pswitch penum
  Playback channels: Front Left - Front Right
  Mono:
  Front Left: Playback [off]
  Front Right: Playback [off]
Simple mixer control 'Aux',0
  Capabilities: pvolume cvolume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 100 Capture 0 - 100
  Front Left: Playback 0 [0%] [-99999.99dB] Capture 0 [0%] [-99999.99dB]
  Front Right: Playback 0 [0%] [-99999.99dB] Capture 0 [0%] [-99999.99dB]
Simple mixer control '0202 DAC Left',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Dock ADC1 Left'
Simple mixer control '0202 DAC Right',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'Dock ADC1 Right'
Simple mixer control '1010 ADAT 0',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 0'
Simple mixer control '1010 ADAT 1',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 1'
Simple mixer control '1010 ADAT 2',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 2'
Simple mixer control '1010 ADAT 3',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 3'
Simple mixer control '1010 ADAT 4',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 4'
Simple mixer control '1010 ADAT 5',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 5'
Simple mixer control '1010 ADAT 6',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 6'
Simple mixer control '1010 ADAT 7',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 7'
Simple mixer control '1010 SPDIF Left',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 0'
Simple mixer control '1010 SPDIF Right',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 1'
Simple mixer control 'ADC1 14dB PAD 0202',0
  Capabilities: cswitch cswitch-joined penum
  Capture channels: Mono
  Mono: Capture [off]
Simple mixer control 'ADC1 14dB PAD Audio Dock',0
  Capabilities: cswitch cswitch-joined penum
  Capture channels: Mono
  Mono: Capture [off]
Simple mixer control 'ADC2 14dB PAD Audio Dock',0
  Capabilities: cswitch cswitch-joined penum
  Capture channels: Mono
  Mono: Capture [off]
Simple mixer control 'ADC3 14dB PAD Audio Dock',0
  Capabilities: cswitch cswitch-joined penum
  Capture channels: Mono
  Mono: Capture [off]
Simple mixer control 'Analog Mix',0
  Capabilities: pvolume cvolume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 100 Capture 0 - 100
  Front Left: Playback 99 [99%] [0.40dB] Capture 96 [96%] [-1.60dB]
  Front Right: Playback 99 [99%] [0.40dB] Capture 96 [96%] [-1.60dB]
Simple mixer control 'Clock Internal Rate',0
  Capabilities: enum
  Items: '44100' '48000' 'SPDIF' 'ADAT'
  Item0: '48000'
Simple mixer control 'DAC1 0202 14dB PAD',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [off]
Simple mixer control 'DAC1 Audio Dock 14dB PAD',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'DAC2 Audio Dock 14dB PAD',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'DAC3 Audio Dock 14dB PAD',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'DAC4 Audio Dock 14dB PAD',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'Dock DAC1 Left',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 0'
Simple mixer control 'Dock DAC1 Right',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 1'
Simple mixer control 'Dock DAC2 Left',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 2'
Simple mixer control 'Dock DAC2 Right',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 3'
Simple mixer control 'Dock DAC3 Left',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 4'
Simple mixer control 'Dock DAC3 Right',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 5'
Simple mixer control 'Dock DAC4 Left',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 6'
Simple mixer control 'Dock DAC4 Right',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 7'
Simple mixer control 'Dock Phones Left',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 0'
Simple mixer control 'Dock Phones Right',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 1'
Simple mixer control 'Dock SPDIF Left',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 0'
Simple mixer control 'Dock SPDIF Right',0
  Capabilities: penum
  Items: 'Silence' 'Dock Mic A' 'Dock Mic B' 'Dock ADC1 Left' 'Dock ADC1 Right' 'Dock ADC2 Left' 'Dock ADC2 Right' 'Dock ADC3 Left' 'Dock ADC3 Right' '0202 ADC Left' '0202 ADC Right' '0202 SPDIF Left' '0202 SPDIF Right' 'ADAT 0' 'ADAT 1' 'ADAT 2' 'ADAT 3' 'ADAT 4' 'ADAT 5' 'ADAT 6' 'ADAT 7' 'DSP 0' 'DSP 1' 'DSP 2' 'DSP 3' 'DSP 4' 'DSP 5' 'DSP 6' 'DSP 7' 'DSP 8' 'DSP 9' 'DSP 10' 'DSP 11' 'DSP 12' 'DSP 13' 'DSP 14' 'DSP 15' 'DSP 16' 'DSP 17' 'DSP 18' 'DSP 19' 'DSP 20' 'DSP 21' 'DSP 22' 'DSP 23' 'DSP 24' 'DSP 25' 'DSP 26' 'DSP 27' 'DSP 28' 'DSP 29' 'DSP 30' 'DSP 31'
  Item0: 'DSP 1'
Simple mixer control 'EMU',0
  Capabilities: cvolume penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 100
  Front Left: Capture 92 [92%] [-3.20dB]
  Front Right: Capture 92 [92%] [-3.20dB]

!!-------Mixer controls for card 2 [USB]

Card hw:2 'USB'/'E-MU Systems, Inc. E-MU 0404 | USB at usb-0000:00:04.1-1.3, high speed'
  Mixer name	: 'USB Mixer'
  Components	: 'USB041e:3f04'
  Controls      : 6
  Simple ctrls  : 5
Simple mixer control 'PCM',0
  Capabilities: pvolume pswitch pswitch-joined penum
  Playback channels: Front Left - Front Right - Rear Left - Rear Right
  Limits: Playback 0 - 200
  Mono:
  Front Left: Playback 200 [100%] [0.00dB] [on]
  Front Right: Playback 200 [100%] [0.00dB] [on]
  Rear Left: Playback 0 [0%] [0.00dB] [on]
  Rear Right: Playback 0 [0%] [0.00dB] [on]
Simple mixer control 'Extension Unit',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [off]
Simple mixer control 'Extension Unit',1
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'Extension Unit',2
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'Extension Unit',3
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [on]


!!Alsactl output
!!-------------

--startcollapse--
state.NVidia {
	control.1 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 39'
		comment.dbmin -5850
		comment.dbmax 0
		iface MIXER
		name 'Front Playback Volume'
		value.0 39
		value.1 39
	}
	control.2 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Front Playback Switch'
		value.0 true
		value.1 true
	}
	control.3 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 39'
		comment.dbmin -5850
		comment.dbmax 0
		iface MIXER
		name 'Surround Playback Volume'
		value.0 39
		value.1 39
	}
	control.4 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Surround Playback Switch'
		value.0 true
		value.1 true
	}
	control.5 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 39'
		comment.dbmin -5850
		comment.dbmax 0
		iface MIXER
		name 'Center Playback Volume'
		value 39
	}
	control.6 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 39'
		comment.dbmin -5850
		comment.dbmax 0
		iface MIXER
		name 'LFE Playback Volume'
		value 39
	}
	control.7 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Center Playback Switch'
		value true
	}
	control.8 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'LFE Playback Switch'
		value true
	}
	control.9 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 39'
		comment.dbmin -5850
		comment.dbmax 0
		iface MIXER
		name 'Side Playback Volume'
		value.0 39
		value.1 39
	}
	control.10 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Side Playback Switch'
		value.0 true
		value.1 true
	}
	control.11 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Headphone Playback Switch'
		value.0 true
		value.1 true
	}
	control.12 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Mic Playback Volume'
		value.0 12
		value.1 12
	}
	control.13 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Mic Playback Switch'
		value.0 true
		value.1 true
	}
	control.14 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Mic Boost'
		value.0 1
		value.1 1
	}
	control.15 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Front Mic Playback Volume'
		value.0 31
		value.1 31
	}
	control.16 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Front Mic Playback Switch'
		value.0 true
		value.1 true
	}
	control.17 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Front Mic Boost'
		value.0 1
		value.1 1
	}
	control.18 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Line Playback Volume'
		value.0 11
		value.1 11
	}
	control.19 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Line Playback Switch'
		value.0 true
		value.1 true
	}
	control.20 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Front Line Playback Volume'
		value.0 31
		value.1 31
	}
	control.21 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Front Line Playback Switch'
		value.0 true
		value.1 true
	}
	control.22 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'CD Playback Volume'
		value.0 31
		value.1 31
	}
	control.23 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'CD Playback Switch'
		value.0 true
		value.1 true
	}
	control.24 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Aux Playback Volume'
		value.0 31
		value.1 31
	}
	control.25 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Aux Playback Switch'
		value.0 true
		value.1 true
	}
	control.26 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'Analog Mix Playback Volume'
		value.0 31
		value.1 31
	}
	control.27 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Analog Mix Playback Switch'
		value.0 true
		value.1 true
	}
	control.28 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 54'
		comment.dbmin -5850
		comment.dbmax 2250
		iface MIXER
		name 'Capture Volume'
		value.0 54
		value.1 54
	}
	control.29 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		value.0 true
		value.1 true
	}
	control.30 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 54'
		comment.dbmin -5850
		comment.dbmax 2250
		iface MIXER
		name 'Capture Volume'
		index 1
		value.0 39
		value.1 39
	}
	control.31 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 1
		value.0 false
		value.1 false
	}
	control.32 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 54'
		comment.dbmin -5850
		comment.dbmax 2250
		iface MIXER
		name 'Capture Volume'
		index 2
		value.0 39
		value.1 39
	}
	control.33 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 2
		value.0 false
		value.1 false
	}
	control.34 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Mic
		comment.item.1 'Front Mic'
		comment.item.2 Line
		comment.item.3 'Front Line'
		comment.item.4 CD
		comment.item.5 Aux
		comment.item.6 Mix
		iface MIXER
		name 'Input Source'
		value 'Front Mic'
	}
	control.35 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Mic
		comment.item.1 'Front Mic'
		comment.item.2 Line
		comment.item.3 'Front Line'
		comment.item.4 CD
		comment.item.5 Aux
		comment.item.6 Mix
		iface MIXER
		name 'Input Source'
		index 1
		value Mic
	}
	control.36 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Mic
		comment.item.1 'Front Mic'
		comment.item.2 Line
		comment.item.3 'Front Line'
		comment.item.4 CD
		comment.item.5 Aux
		comment.item.6 Mix
		iface MIXER
		name 'Input Source'
		index 2
		value Mic
	}
	control.37 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 39'
		comment.dbmin -5850
		comment.dbmax 0
		iface MIXER
		name 'IEC958 Playback Volume'
		value.0 39
		value.1 39
	}
	control.38 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 PCM
		comment.item.1 ADC1
		comment.item.2 ADC2
		comment.item.3 ADC3
		iface MIXER
		name 'IEC958 Playback Source'
		value PCM
	}
	control.39 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Con Mask'
		value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.40 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Pro Mask'
		value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.41 {
		comment.access 'read write'
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Default'
		value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.42 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Switch'
		value true
	}
	control.43 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Default PCM Playback Switch'
		value true
	}
	control.44 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 15'
		comment.dbmin -4500
		comment.dbmax 0
		iface MIXER
		name 'Beep Playback Volume'
		value 15
	}
	control.45 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Beep Playback Switch'
		value true
	}
	control.46 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 39'
		comment.dbmin -5850
		comment.dbmax 0
		iface MIXER
		name 'Master Playback Volume'
		value 38
	}
	control.47 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Master Playback Switch'
		value true
	}
	control.48 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Con Mask'
		index 1
		value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.49 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Pro Mask'
		index 1
		value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.50 {
		comment.access 'read write'
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Default'
		index 1
		value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.51 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Switch'
		index 1
		value false
	}
	control.52 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 255'
		comment.tlv '0000000100000008ffffec1400000014'
		comment.dbmin -5100
		comment.dbmax 0
		iface MIXER
		name 'PCM Playback Volume'
		value.0 250
		value.1 250
	}
}
state.EMU0404 {
	control.1 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'PCM Front Playback Volume'
		value.0 100
		value.1 100
	}
	control.2 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'PCM Surround Playback Volume'
		value.0 100
		value.1 100
	}
	control.3 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'PCM Side Playback Volume'
		value.0 100
		value.1 100
	}
	control.4 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'PCM Center Playback Volume'
		value 100
	}
	control.5 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'PCM LFE Playback Volume'
		value 100
	}
	control.6 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'PCM Playback Volume'
		value.0 100
		value.1 100
	}
	control.7 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Synth Playback Volume'
		value.0 80
		value.1 80
	}
	control.8 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'PCM Capture Volume'
		value.0 100
		value.1 100
	}
	control.9 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Synth Capture Volume'
		value.0 100
		value.1 100
	}
	control.10 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'EMU Capture Volume'
		value.0 92
		value.1 92
	}
	control.11 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Mic Playback Volume'
		value.0 94
		value.1 94
	}
	control.12 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Mic Capture Volume'
		value.0 99
		value.1 100
	}
	control.13 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'CD Playback Volume'
		value.0 31
		value.1 31
	}
	control.14 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'CD Capture Volume'
		value.0 30
		value.1 30
	}
	control.15 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'IEC958 Optical Playback Volume'
		value.0 0
		value.1 0
	}
	control.16 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'IEC958 Optical Capture Volume'
		value.0 0
		value.1 0
	}
	control.17 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Line Playback Volume'
		value.0 100
		value.1 97
	}
	control.18 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Line Capture Volume'
		value.0 100
		value.1 100
	}
	control.19 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Analog Mix Playback Volume'
		value.0 99
		value.1 99
	}
	control.20 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Analog Mix Capture Volume'
		value.0 96
		value.1 96
	}
	control.21 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Aux Playback Volume'
		value.0 0
		value.1 0
	}
	control.22 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Aux Capture Volume'
		value.0 0
		value.1 0
	}
	control.23 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Front Playback Volume'
		value.0 100
		value.1 100
	}
	control.24 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Surround Playback Volume'
		value.0 100
		value.1 100
	}
	control.25 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Center Playback Volume'
		value 100
	}
	control.26 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'LFE Playback Volume'
		value 100
	}
	control.27 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Side Playback Volume'
		value.0 100
		value.1 100
	}
	control.28 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 40'
		iface MIXER
		name 'Tone Control - Bass'
		value.0 20
		value.1 20
	}
	control.29 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 40'
		iface MIXER
		name 'Tone Control - Treble'
		value.0 20
		value.1 20
	}
	control.30 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Tone Control - Switch'
		value.0 false
		value.1 false
	}
	control.31 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 100'
		comment.dbmin -4000
		comment.dbmax 0
		iface MIXER
		name 'Master Playback Volume'
		value 99
	}
	control.32 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'IEC958 Optical Raw Playback Switch'
		value.0 false
		value.1 false
	}
	control.33 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 64
		iface PCM
		device 2
		name 'Captured FX8010 Outputs'
		value.0 false
		value.1 false
		value.2 false
		value.3 false
		value.4 false
		value.5 false
		value.6 false
		value.7 false
		value.8 false
		value.9 false
		value.10 false
		value.11 false
		value.12 false
		value.13 false
		value.14 false
		value.15 false
		value.16 false
		value.17 false
		value.18 false
		value.19 false
		value.20 false
		value.21 false
		value.22 false
		value.23 false
		value.24 false
		value.25 false
		value.26 false
		value.27 false
		value.28 false
		value.29 false
		value.30 false
		value.31 false
		value.32 true
		value.33 true
		value.34 true
		value.35 true
		value.36 true
		value.37 true
		value.38 true
		value.39 true
		value.40 true
		value.41 true
		value.42 true
		value.43 true
		value.44 true
		value.45 true
		value.46 true
		value.47 true
		value.48 true
		value.49 true
		value.50 true
		value.51 true
		value.52 true
		value.53 true
		value.54 true
		value.55 true
		value.56 true
		value.57 true
		value.58 true
		value.59 true
		value.60 true
		value.61 true
		value.62 true
		value.63 true
	}
	control.178 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface PCM
		name 'IEC958 Playback Mask'
		value ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
	}
	control.179 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface PCM
		name 'IEC958 Playback Mask'
		index 1
		value ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
	}
	control.180 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface PCM
		name 'IEC958 Playback Mask'
		index 2
		value ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
	}
	control.181 {
		comment.access 'read write'
		comment.type IEC958
		comment.count 1
		iface PCM
		name 'IEC958 Playback Default'
		value '0492100200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.182 {
		comment.access 'read write'
		comment.type IEC958
		comment.count 1
		iface PCM
		name 'IEC958 Playback Default'
		index 1
		value '0492100200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.183 {
		comment.access 'read write'
		comment.type IEC958
		comment.count 1
		iface PCM
		name 'IEC958 Playback Default'
		index 2
		value '0492100200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.184 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'Dock DAC1 Left Playback Enum'
		value 'DSP 0'
	}
	control.185 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'Dock DAC1 Right Playback Enum'
		value 'DSP 1'
	}
	control.186 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'Dock DAC2 Left Playback Enum'
		value 'DSP 2'
	}
	control.187 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'Dock DAC2 Right Playback Enum'
		value 'DSP 3'
	}
	control.188 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'Dock DAC3 Left Playback Enum'
		value 'DSP 4'
	}
	control.189 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'Dock DAC3 Right Playback Enum'
		value 'DSP 5'
	}
	control.190 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'Dock DAC4 Left Playback Enum'
		value 'DSP 6'
	}
	control.191 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'Dock DAC4 Right Playback Enum'
		value 'DSP 7'
	}
	control.192 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'Dock Phones Left Playback Enum'
		value 'DSP 0'
	}
	control.193 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'Dock Phones Right Playback Enum'
		value 'DSP 1'
	}
	control.194 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'Dock SPDIF Left Playback Enum'
		value 'DSP 0'
	}
	control.195 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'Dock SPDIF Right Playback Enum'
		value 'DSP 1'
	}
	control.196 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name '1010 SPDIF Left Playback Enum'
		value 'DSP 0'
	}
	control.197 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name '1010 SPDIF Right Playback Enum'
		value 'DSP 1'
	}
	control.198 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name '0202 DAC Left Playback Enum'
		value 'Dock ADC1 Left'
	}
	control.199 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name '0202 DAC Right Playback Enum'
		value 'Dock ADC1 Right'
	}
	control.200 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name '1010 ADAT 0 Playback Enum'
		value 'DSP 0'
	}
	control.201 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name '1010 ADAT 1 Playback Enum'
		value 'DSP 1'
	}
	control.202 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name '1010 ADAT 2 Playback Enum'
		value 'DSP 2'
	}
	control.203 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name '1010 ADAT 3 Playback Enum'
		value 'DSP 3'
	}
	control.204 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name '1010 ADAT 4 Playback Enum'
		value 'DSP 4'
	}
	control.205 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name '1010 ADAT 5 Playback Enum'
		value 'DSP 5'
	}
	control.206 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name '1010 ADAT 6 Playback Enum'
		value 'DSP 6'
	}
	control.207 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name '1010 ADAT 7 Playback Enum'
		value 'DSP 7'
	}
	control.208 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 0 Capture Enum'
		value '0202 ADC Left'
	}
	control.209 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 1 Capture Enum'
		value '0202 ADC Right'
	}
	control.210 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 2 Capture Enum'
		value Silence
	}
	control.211 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 3 Capture Enum'
		value Silence
	}
	control.212 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 4 Capture Enum'
		value Silence
	}
	control.213 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 5 Capture Enum'
		value Silence
	}
	control.214 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 6 Capture Enum'
		value Silence
	}
	control.215 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 7 Capture Enum'
		value Silence
	}
	control.216 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 8 Capture Enum'
		value Silence
	}
	control.217 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 9 Capture Enum'
		value Silence
	}
	control.218 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP A Capture Enum'
		value Silence
	}
	control.219 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP B Capture Enum'
		value Silence
	}
	control.220 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP C Capture Enum'
		value Silence
	}
	control.221 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP D Capture Enum'
		value Silence
	}
	control.222 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP E Capture Enum'
		value Silence
	}
	control.223 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP F Capture Enum'
		value Silence
	}
	control.224 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 10 Capture Enum'
		value Silence
	}
	control.225 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 11 Capture Enum'
		value Silence
	}
	control.226 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 12 Capture Enum'
		value Silence
	}
	control.227 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 13 Capture Enum'
		value Silence
	}
	control.228 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 14 Capture Enum'
		value Silence
	}
	control.229 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Silence
		comment.item.1 'Dock Mic A'
		comment.item.2 'Dock Mic B'
		comment.item.3 'Dock ADC1 Left'
		comment.item.4 'Dock ADC1 Right'
		comment.item.5 'Dock ADC2 Left'
		comment.item.6 'Dock ADC2 Right'
		comment.item.7 'Dock ADC3 Left'
		comment.item.8 'Dock ADC3 Right'
		comment.item.9 '0202 ADC Left'
		comment.item.10 '0202 ADC Right'
		comment.item.11 '0202 SPDIF Left'
		comment.item.12 '0202 SPDIF Right'
		comment.item.13 'ADAT 0'
		comment.item.14 'ADAT 1'
		comment.item.15 'ADAT 2'
		comment.item.16 'ADAT 3'
		comment.item.17 'ADAT 4'
		comment.item.18 'ADAT 5'
		comment.item.19 'ADAT 6'
		comment.item.20 'ADAT 7'
		comment.item.21 'DSP 0'
		comment.item.22 'DSP 1'
		comment.item.23 'DSP 2'
		comment.item.24 'DSP 3'
		comment.item.25 'DSP 4'
		comment.item.26 'DSP 5'
		comment.item.27 'DSP 6'
		comment.item.28 'DSP 7'
		comment.item.29 'DSP 8'
		comment.item.30 'DSP 9'
		comment.item.31 'DSP 10'
		comment.item.32 'DSP 11'
		comment.item.33 'DSP 12'
		comment.item.34 'DSP 13'
		comment.item.35 'DSP 14'
		comment.item.36 'DSP 15'
		comment.item.37 'DSP 16'
		comment.item.38 'DSP 17'
		comment.item.39 'DSP 18'
		comment.item.40 'DSP 19'
		comment.item.41 'DSP 20'
		comment.item.42 'DSP 21'
		comment.item.43 'DSP 22'
		comment.item.44 'DSP 23'
		comment.item.45 'DSP 24'
		comment.item.46 'DSP 25'
		comment.item.47 'DSP 26'
		comment.item.48 'DSP 27'
		comment.item.49 'DSP 28'
		comment.item.50 'DSP 29'
		comment.item.51 'DSP 30'
		comment.item.52 'DSP 31'
		iface MIXER
		name 'DSP 15 Capture Enum'
		value Silence
	}
	control.230 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'ADC1 14dB PAD Audio Dock Capture Switch'
		value false
	}
	control.231 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'ADC2 14dB PAD Audio Dock Capture Switch'
		value false
	}
	control.232 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'ADC3 14dB PAD Audio Dock Capture Switch'
		value false
	}
	control.233 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'ADC1 14dB PAD 0202 Capture Switch'
		value false
	}
	control.234 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'DAC1 Audio Dock 14dB PAD Playback Switch'
		value true
	}
	control.235 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'DAC2 Audio Dock 14dB PAD Playback Switch'
		value true
	}
	control.236 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'DAC3 Audio Dock 14dB PAD Playback Switch'
		value true
	}
	control.237 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'DAC4 Audio Dock 14dB PAD Playback Switch'
		value true
	}
	control.238 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'DAC1 0202 14dB PAD Playback Switch'
		value false
	}
	control.239 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 '44100'
		comment.item.1 '48000'
		comment.item.2 SPDIF
		comment.item.3 ADAT
		iface MIXER
		name 'Clock Internal Rate'
		value '48000'
	}
}
state.USB {
	control.1 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'PCM Playback Switch'
		value true
	}
	control.2 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 4
		comment.range '0 - 200'
		comment.dbmin 0
		comment.dbmax 0
		iface MIXER
		name 'PCM Playback Volume'
		value.0 200
		value.1 200
		value.2 0
		value.3 0
	}
	control.3 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Extension Unit Switch'
		value false
	}
	control.4 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Extension Unit Switch'
		index 1
		value true
	}
	control.5 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Extension Unit Switch'
		index 2
		value true
	}
	control.6 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Extension Unit Switch'
		index 3
		value true
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
ipt_REJECT
xt_tcpudp
iptable_filter
ip_tables
x_tables
vboxnetadp
vboxnetflt
vboxdrv
bluetooth
af_packet
nfsd
snd_pcm_oss
lockd
nfs_acl
snd_mixer_oss
auth_rpcgss
sunrpc
snd_emu10k1_synth
binfmt_misc
snd_emux_synth
snd_seq_virmidi
snd_seq_midi_emul
snd_seq_midi
snd_seq_midi_event
snd_seq
bridge
stp
llc
fuse
loop
dm_mod
i2c_dev
dvb_pll
mt352
cx88_dvb
cx88_vp3054_i2c
videobuf_dvb
dvb_core
snd_hda_codec_nvhdmi
snd_hda_codec_analog
arc4
ecb
rt73usb
rt2500usb
rt2x00usb
rt2x00lib
cx8800
cx8802
cx88xx
led_class
snd_emu10k1
gspca_m5602
ir_common
snd_ac97_codec
i2c_algo_bit
snd_hda_intel
gspca_main
v4l2_common
snd_hda_codec
ac97_bus
mac80211
tveeprom
snd_usb_audio
videodev
joydev
nvidia
ir_core
snd_usb_lib
ohci1394
snd_pcm
cp210x
cfg80211
kvm_amd
video
v4l1_compat
usbhid
usblp
pl2303
usb_storage
videobuf_dma_sg
snd_util_mem
snd_rawmidi
snd_timer
sr_mod
sky2
k10temp
forcedeth
v4l2_compat_ioctl32
agpgart
serio_raw
hid
edac_core
videobuf_core
btcx_risc
usb_libusual
ieee1394
i2c_nforce2
usbserial
snd_hwdep
snd_seq_device
button
rfkill
sg
cdrom
output
asus_atk0110
kvm
snd
snd_page_alloc
soundcore
ohci_hcd
rtc_cmos
sd_mod
rtc_core
crc_t10dif
ehci_hcd
rtc_lib
usbcore
edd
xfs
exportfs
w83791d
hwmon_vid
i2c_core
k8temp
reiserfs
jfs
ahci
fan
processor
ide_pci_generic
amd74xx
ide_core
ata_generic
pata_amd
libata
scsi_mod
thermal
thermal_sys
hwmon
netconsole
configfs


!!Sysfs Files
!!-----------

/sys/class/sound/hwC0D0/init_pin_configs:
0x11 0x02214030
0x12 0x01014010
0x13 0x511711f0
0x14 0x02a1902e
0x15 0x01813021
0x16 0x01011012
0x17 0x01a19020
0x18 0x99331122
0x1a 0x91f711f0
0x1b 0x0145f1f0
0x1c 0x41c5f1f0
0x24 0x01016011
0x25 0x01012014

/sys/class/sound/hwC0D0/driver_pin_configs:

/sys/class/sound/hwC0D0/user_pin_configs:

/sys/class/sound/hwC0D0/init_verbs:

/sys/class/sound/hwC0D3/init_pin_configs:
0x05 0x18560110
0x07 0x58560121
0x09 0x58560122
0x0b 0x58560123
0x0d 0x58560124

/sys/class/sound/hwC0D3/driver_pin_configs:

/sys/class/sound/hwC0D3/user_pin_configs:

/sys/class/sound/hwC0D3/init_verbs:


!!ALSA/HDA dmesg
!!------------------

ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 20
HDA Intel 0000:00:07.0: PCI INT A -> Link[AAZA] -> GSI 20 (level, low) -> IRQ 20
HDA Intel 0000:00:07.0: irq 30 for MSI/MSI-X
HDA Intel 0000:00:07.0: setting latency timer to 64
gspca: probing 0402:5602
--
EMU10K1_Audigy 0000:01:08.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -> IRQ 16
ALSA sound/pci/emu10k1/emu10k1_main.c:811: emu1010: Special config.
ALSA sound/pci/emu10k1/emu10k1_main.c:850: emu1010: EMU_HANA_ID = 0x3f
ALSA sound/pci/emu10k1/emu10k1_main.c:869: emu1010: filename emu/emu0404.fw testing
EMU10K1_Audigy 0000:01:08.0: firmware: requesting emu/emu0404.fw
--
usbcore: registered new interface driver rt2500usb
ALSA sound/pci/emu10k1/emu10k1_main.c:674: firmware size = 0xd67c
phy1: Selected rate control algorithm 'minstrel'
--
usbcore: registered new interface driver rt73usb
ALSA sound/pci/emu10k1/emu10k1_main.c:886: emu1010: Hana Firmware loaded
ALSA sound/pci/emu10k1/emu10k1_main.c:889: emu1010: Hana version: 1.1
ALSA sound/pci/emu10k1/emu10k1_main.c:894: emu1010: Card options = 0x1
ALSA sound/pci/emu10k1/emu10k1_main.c:896: emu1010: Card options = 0x1
ALSA sound/pci/emu10k1/emu10k1_main.c:935: emu1010: Card options3 = 0x1
ALSA sound/pci/emu10k1/emu10k1_main.c:219: Audigy2 value: Special config.
ALSA sound/pci/emu10k1/emufx.c:1522: EMU outputs on
ALSA sound/pci/emu10k1/emufx.c:1570: EMU2 inputs on
cx88[0]: subsystem: 17de:08a6, board: KWorld/VStream XPert DVB-T [card=14,autodetected], frontend(s): 1
cx88[0]: TV tuner type 4, Radio tuner type -1
hda_codec: AD1988B: BIOS auto-probing.
ALSA sound/pci/hda/hda_codec.c:4284: autoconfig: line_outs=4 (0x12/0x16/0x24/0x25/0x0)
ALSA sound/pci/hda/hda_codec.c:4288:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4292:    hp_outs=1 (0x11/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4293:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:4296:    dig-out=0x1b/0x0
ALSA sound/pci/hda/hda_codec.c:4304:    inputs: mic=0x17, fmic=0x14, line=0x15, fline=0x0, cd=0x18, aux=0x0
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:07.0/input/input8
input: cx88 IR (KWorld/VStream XPert D as /devices/pci0000:00/0000:00:08.0/0000:01:09.2/input/input9
--
ip_tables: (C) 2000-2006 Netfilter Core Team
ALSA sound/usb/usbaudio.c:354: frame 1 active: -71
kmemleak: 27 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
kmemleak: 12 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
ALSA sound/usb/usbaudio.c:354: frame 0 active: -75
ALSA sound/usb/usbaudio.c:354: frame 0 active: -75
ALSA sound/usb/usbaudio.c:354: frame 0 active: -71
kmemleak: 3 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:708: cannot submit urb (err = -27)
ALSA sound/usb/usbaudio.c:731: cannot submit sync urb (err = -27)
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:708: cannot submit urb (err = -27)
ALSA sound/usb/usbaudio.c:731: cannot submit sync urb (err = -27)
kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:708: cannot submit urb (err = -27)
ALSA sound/usb/usbaudio.c:731: cannot submit sync urb (err = -27)
kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:708: cannot submit urb (err = -27)
ALSA sound/usb/usbaudio.c:731: cannot submit sync urb (err = -27)
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:708: cannot submit urb (err = -27)
ALSA sound/usb/usbaudio.c:731: cannot submit sync urb (err = -27)
kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:708: cannot submit urb (err = -27)
ALSA sound/usb/usbaudio.c:731: cannot submit sync urb (err = -27)
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:708: cannot submit urb (err = -27)
ALSA sound/usb/usbaudio.c:731: cannot submit sync urb (err = -27)
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:708: cannot submit urb (err = -27)
ALSA sound/usb/usbaudio.c:731: cannot submit sync urb (err = -27)
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:708: cannot submit urb (err = -27)
ALSA sound/usb/usbaudio.c:731: cannot submit sync urb (err = -27)
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:708: cannot submit urb (err = -27)
ALSA sound/usb/usbaudio.c:731: cannot submit sync urb (err = -27)
usb 2-2: USB disconnect, address 3
--
sd 11:0:0:0: [sdd] Attached SCSI removable disk
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:708: cannot submit urb (err = -27)
ALSA sound/usb/usbaudio.c:731: cannot submit sync urb (err = -27)
kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
ALSA sound/pci/hda/hda_intel.c:694: azx_get_response timeout, switching to polling mode: last cmd=0x001f000a



--------------050108090109080306090504--

