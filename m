Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465Ab0COAGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 20:06:15 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63276 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886Ab0COAGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 20:06:13 -0400
Message-ID: <4B9D79F9.9080607@alessandroguido.name>
Date: Mon, 15 Mar 2010 01:06:17 +0100
From: Alessandro Guido <ag@alessandroguido.name>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100310 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [2.6.34-rc1 REGRESSION] alsa: no mixer controls (and no sound) with
 2.6.24-rc1+ on Realtek ALC260
Content-Type: multipart/mixed;
 boundary="------------010007020206010407050603"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010007020206010407050603
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

With 2.6.34-rc1+ my laptop (Sony Vaio VGN-FS215S) can't reproduce any 
sound. All controls are missing from alsamixer and this message is found 
in dmesg:

	hda_codec: cannot build controlsfor #0 (error -22)

Kernel config is attached, and the output from alsa-info.sh follows:

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.59
!!################################

!!Script ran on: Sun Mar 14 23:57:30 UTC 2010


!!Linux Distribution
!!------------------

Gentoo Base System release 2.0.1


!!DMI Information
!!---------------

Manufacturer:
Product Name:


!!Kernel Information
!!------------------

Kernel release:    2.6.34-rc1-909-gd89b218
Operating System:  GNU/Linux
Architecture:      i686
Processor:         Intel(R) Pentium(R) M processor 1.86GHz
SMP Enabled:       No


!!ALSA Version
!!------------

Driver version:     1.0.22.1
Library version:    1.0.22
Utilities version:  1.0.22


!!Loaded ALSA modules
!!-------------------



!!Sound Servers on this system
!!----------------------------

No sound servers found.


!!Soundcards recognised by ALSA
!!-----------------------------

  0 [Intel          ]: HDA-Intel - HDA Intel
                       HDA Intel at 0x80000000 irq 25


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 
Family) High Definition Audio Controller (rev 03)


!!Advanced information - PCI Vendor/Device/Susbsystem ID's
!!--------------------------------------------------------

00:1b.0 0403: 8086:2668 (rev 03)
	Subsystem: 104d:81bb


!!Loaded sound module options
!!--------------------------


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: Realtek ALC260
Address: 0
Function Id: 0x1
Vendor Id: 0x10ec0260
Subsystem Id: 0x104d0000
Revision Id: 0x100300
No Modem Function Group found
Default PCM:
     rates [0x560]: 44100 48000 96000 192000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=4, o=0, i=0, unsolicited=1, wake=0
   IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
   IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
   IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
   IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0x11: Stereo
   Converter: stream=0, channel=0
   PCM:
     rates [0x560]: 44100 48000 96000 192000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x03 [Audio Output] wcaps 0x211: Stereo Digital
   Converter: stream=0, channel=0
   Digital:
   Digital category: 0x0
   PCM:
     rates [0x560]: 44100 48000 96000 192000
     bits [0x1e]: 16 20 24 32
     formats [0x1]: PCM
Node 0x04 [Audio Input] wcaps 0x10011b: Stereo Amp-In
   Amp-In caps: ofs=0x00, nsteps=0x23, stepsize=0x03, mute=1
   Amp-In vals:  [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 
0x00] [0x00 0x00] [0x00 0x00]
   Converter: stream=0, channel=0
   SDI-Select: 0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0x6]: 16 20
     formats [0x1]: PCM
   Connection: 7
      0x12 0x13 0x14* 0x15 0x16 0x0f 0x10
Node 0x05 [Audio Input] wcaps 0x10011b: Stereo Amp-In
   Amp-In caps: ofs=0x00, nsteps=0x23, stepsize=0x03, mute=1
   Amp-In vals:  [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 
0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00]
   Converter: stream=0, channel=0
   SDI-Select: 0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0x6]: 16 20
     formats [0x1]: PCM
   Connection: 8
      0x12 0x13 0x14* 0x15 0x16 0x07 0x0f 0x10
Node 0x06 [Audio Input] wcaps 0x100391: Stereo Digital
   Converter: stream=0, channel=0
   SDI-Select: 0
   Digital:
   Digital category: 0x0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0x1e]: 16 20 24 32
     formats [0x1]: PCM
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x19
Node 0x07 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Amp-In caps: ofs=0x23, nsteps=0x41, stepsize=0x03, mute=1
   Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 
0x80] [0xa3 0xa3] [0xa3 0xa3] [0xa3 0xa3]
   Connection: 8
      0x12 0x13 0x14 0x15 0x16 0x17 0x0f 0x10
Node 0x08 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x80 0x80] [0x80 0x80]
   Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
   Amp-Out vals:  [0x00 0x00]
   Connection: 2
      0x02 0x07
Node 0x09 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x80 0x80] [0x80 0x80]
   Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
   Amp-Out vals:  [0x00 0x00]
   Connection: 2
      0x02 0x07
Node 0x0a [Audio Mixer] wcaps 0x20010e: Mono Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x80] [0x80]
   Amp-Out caps: ofs=0x23, nsteps=0x41, stepsize=0x03, mute=0
   Amp-Out vals:  [0x00]
   Connection: 2
      0x02 0x07
Node 0x0b [Audio Selector] wcaps 0x300101: Stereo
   Connection: 2
      0x08* 0x09
Node 0x0c [Audio Selector] wcaps 0x300101: Stereo
   Connection: 2
      0x08* 0x09
Node 0x0d [Audio Selector] wcaps 0x300101: Stereo
   Connection: 2
      0x08* 0x09
Node 0x0e [Audio Selector] wcaps 0x300101: Stereo
   Connection: 2
      0x08* 0x09
Node 0x0f [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x0001003f: IN OUT HP EAPD Detect Trigger ImpSense
   EAPD 0x0:
   Pin Default 0x02014110: [Jack] Line Out at Ext Front
     Conn = 1/8, Color = Green
     DefAssociation = 0x1, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x00:
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x08
Node 0x10 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x0001003f: IN OUT HP EAPD Detect Trigger ImpSense
   EAPD 0x0:
   Pin Default 0x21011120: [Jack] Line Out at Sep Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0x2, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x00:
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x09
Node 0x11 [Pin Complex] wcaps 0x40010c: Mono Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00]
   Pincap 0x00000010: OUT
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x00:
   Connection: 1
      0x0a
Node 0x12 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x0000133f: IN OUT HP Detect Trigger ImpSense
     Vref caps: HIZ 50 80
   Pin Default 0x02a15910: [Jack] Mic at Ext Front
     Conn = 1/8, Color = Red
     DefAssociation = 0x1, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x00: VREF_HIZ
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0b
Node 0x13 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x0000133f: IN OUT HP Detect Trigger ImpSense
     Vref caps: HIZ 50 80
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x00: VREF_HIZ
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0c
Node 0x14 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x0000133f: IN OUT HP Detect Trigger ImpSense
     Vref caps: HIZ 50 80
   Pin Default 0x21845120: [Jack] Line In at Sep Rear
     Conn = RCA, Color = Red
     DefAssociation = 0x2, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x00: VREF_HIZ
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0d
Node 0x15 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x0000133f: IN OUT HP Detect Trigger ImpSense
     Vref caps: HIZ 50 80
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x00: VREF_HIZ
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0e
Node 0x16 [Pin Complex] wcaps 0x400001: Stereo
   Pincap 0x00000020: IN
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x00:
Node 0x17 [Pin Complex] wcaps 0x400000: Mono
   Pincap 0x00000020: IN
   Pin Default 0x99831140: [Fixed] Line In at Int ATAPI
     Conn = ATAPI, Color = Black
     DefAssociation = 0x4, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x00:
Node 0x18 [Pin Complex] wcaps 0x400380: Mono Digital
   Pincap 0x00000014: OUT Detect
   Pin Default 0x21451130: [Jack] SPDIF Out at Sep Rear
     Conn = Optical, Color = Black
     DefAssociation = 0x3, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x00:
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x03
Node 0x19 [Pin Complex] wcaps 0x400280: Mono Digital
   Pincap 0x00000024: IN Detect
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x00:
   Unsolicited: tag=00, enabled=0
Node 0x1a [Vendor Defined Widget] wcaps 0xf00040: Mono
   Processing caps: benign=0, ncoeff=13
Node 0x1b [Volume Knob Widget] wcaps 0x600080: Mono
   Volume-Knob: delta=0, steps=64, direct=0, val=0
   Unsolicited: tag=00, enabled=0
   Connection: 0
Codec: Conexant ID 2bfa
Address: 1
Function Id: 0x2
Vendor Id: 0x14f12bfa
Subsystem Id: 0x104d0200
Revision Id: 0x90000
Modem Function Group: 0x2
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw---- 1 root audio 116,  0 Mar 14 23:08 /dev/snd/controlC0
crw-rw---- 1 root audio 116, 33 Mar 14 23:08 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root  60 Mar 14 23:08 .
drwxr-xr-x 3 root root 100 Mar 14 23:08 ..
lrwxrwxrwx 1 root root  12 Mar 14 23:08 pci-0000:00:1b.0 -> ../controlC0


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****

ARECORD

**** List of CAPTURE Hardware Devices ****

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0x80000000 irq 25'
   Mixer name	: 'Realtek ALC260'
   Components	: 'HDA:10ec0260,104d0000,00100300 
HDA:14f12bfa,104d0200,00090000'
   Controls      : 0
   Simple ctrls  : 0


!!Alsactl output
!!-------------

--startcollapse--
state.Intel {
	control {
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module


!!ALSA/HDA dmesg
!!------------------

input: Sony Vaio Jogdial as /devices/virtual/input/input4
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
HDA Intel 0000:00:1b.0: irq 25 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: cannot build controlsfor #0 (error -22)
ALSA device list:
   #0: HDA Intel at 0x80000000 irq 25
TCP cubic registered




--------------010007020206010407050603
Content-Type: application/x-gzip;
 name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="config.gz"

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
nK4uhoRbfgWgBrzqbhsCY8JefwG5rro3lskAAA==
--------------010007020206010407050603--
