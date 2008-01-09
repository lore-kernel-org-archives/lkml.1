Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbYAIGDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbYAIGDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 01:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYAIGD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 01:03:27 -0500
Received: from mailout04.sul.t-online.de ([194.25.134.18]:41998 "EHLO
	mailout04.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997AbYAIGDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 01:03:23 -0500
Message-ID: <478463A6.2070106@t-online.de>
Date: Wed, 09 Jan 2008 07:03:18 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc7, intel audio: alsa doesn't say a beep
References: <4782833D.3010600@t-online.de>	<s5h3at8rd9c.wl%tiwai@suse.de>	<4783AC7C.50900@t-online.de> <s5h63y42oy6.wl%tiwai@suse.de>
In-Reply-To: <s5h63y42oy6.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: VaxJxmZrYhcg0lT+ucoefw7Cxhq24io3KyO0WMAn1RYLT2jzhzj-Y1tGAs4GHJnwTb
X-TOI-MSGID: d07c53a7-2f6e-4d1c-835f-c59176b179bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> 
> Did you enable CONFIG_SND_HDA_POWER_SAVE feature?  And which hardware
> (laptop, product name, whatever) exactly?
> 

CONFIG_SND_HDA_POWER_SAVE is not set.

Hardware is a Dell XPS M1330. CPU is Core2 Duo T7500, 2.20GHz,
2 GByte RAM. lspci:

00:00.0 Host bridge: Intel Corporation Mobile Memory Controller Hub (rev 0c)
00:01.0 PCI bridge: Intel Corporation Mobile PCI Express Root Port (rev 0c)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #5 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 (rev 02)
00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f2)
00:1f.0 ISA bridge: Intel Corporation Mobile LPC Interface Controller (rev 02)
00:1f.1 IDE interface: Intel Corporation Mobile IDE Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation Mobile SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
01:00.0 VGA compatible controller: nVidia Corporation Unknown device 0427 (rev a1)
03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd Unknown device 0832 (rev 05)
03:01.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
03:01.2 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 12)
03:01.3 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 12)
09:00.0 Ethernet controller: Broadcom Corporation Unknown device 1713 (rev 02)
0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)

> Also, please show the contents of /proc/asound/card0/codec#* files.
> Do you see difference in these files between with and without the
> patch?
> 

See below. There is no difference between both.


Regards

Harri
========================================================================
Codec: SigmaTel STAC9228
Address: 0
Vendor Id: 0x83847616
Subsystem Id: 0x10280209
Revision Id: 0x100201
No Modem Function Group found
Default PCM:
     rates [0x7e0]: 44100 48000 88200 96000 176400 192000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Default Amp-In caps: ofs=0x00, nsteps=0x0e, stepsize=0x05, mute=0
Default Amp-Out caps: ofs=0x7f, nsteps=0x7f, stepsize=0x02, mute=1
Node 0x02 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out
   Amp-Out caps: N/A
   Amp-Out vals:  [0x7f 0x7f]
   Power: 0x0
Node 0x03 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out
   Amp-Out caps: N/A
   Amp-Out vals:  [0xff 0xff]
   Power: 0x0
Node 0x04 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out
   Amp-Out caps: N/A
   Amp-Out vals:  [0xff 0xff]
   Power: 0x0
Node 0x05 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out
   Amp-Out caps: N/A
   Amp-Out vals:  [0xff 0xff]
   Power: 0x0
Node 0x06 [Vendor Defined Widget] wcaps 0xfd0c05: Stereo Amp-Out
   Amp-Out caps: N/A
   Amp-Out vals:  [0xff 0xff]
   Power: 0x0
Node 0x07 [Audio Input] wcaps 0x1d0541: Stereo
   Power: 0x0
   Connection: 1
      0x1b
Node 0x08 [Audio Input] wcaps 0x1d0541: Stereo
   Power: 0x0
   Connection: 1
      0x1c
Node 0x09 [Audio Input] wcaps 0x1d0541: Stereo
   Power: 0x0
   Connection: 1
      0x1d
Node 0x0a [Pin Complex] wcaps 0x400181: Stereo
   Pincap 0x08173f: IN OUT HP Detect
   Pin Default 0x02214020: [Jack] HP Out at Ext Front
     Conn = 1/8, Color = Green
   Pin-ctls: 0xc0: OUT HP
   Connection: 2
      0x02* 0x03
Node 0x0b [Pin Complex] wcaps 0x400181: Stereo
   Pincap 0x08173f: IN OUT HP Detect
   Pin Default 0x02a19080: [Jack] Mic at Ext Front
     Conn = 1/8, Color = Pink
   Pin-ctls: 0x24: IN
   Connection: 2
      0x02 0x03*
Node 0x0c [Pin Complex] wcaps 0x400181: Stereo
   Pincap 0x081737: IN OUT Detect
   Pin Default 0x0181304e: [Jack] Line In at Ext Rear
     Conn = 1/8, Color = Blue
   Pin-ctls: 0x20: IN
   Connection: 1
      0x03
Node 0x0d [Pin Complex] wcaps 0x400181: Stereo
   Pincap 0x08173f: IN OUT HP Detect
   Pin Default 0x01014010: [Jack] Line Out at Ext Rear
     Conn = 1/8, Color = Green
   Pin-ctls: 0x40: OUT
   Connection: 1
      0x02
Node 0x0e [Pin Complex] wcaps 0x400181: Stereo
   Pincap 0x081737: IN OUT Detect
   Pin Default 0x01a19040: [Jack] Mic at Ext Rear
     Conn = 1/8, Color = Pink
   Pin-ctls: 0x24: IN
   Connection: 1
      0x04
Node 0x0f [Pin Complex] wcaps 0x400181: Stereo
   Pincap 0x081737: IN OUT Detect
   Pin Default 0x01011012: [Jack] Line Out at Ext Rear
     Conn = 1/8, Color = Black
   Pin-ctls: 0x40: OUT
   Connection: 1
      0x05
Node 0x10 [Pin Complex] wcaps 0x400181: Stereo
   Pincap 0x0837: IN OUT Detect
   Pin Default 0x01016011: [Jack] Line Out at Ext Rear
     Conn = 1/8, Color = Orange
   Pin-ctls: 0x40: OUT
   Connection: 1
      0x04
Node 0x11 [Pin Complex] wcaps 0x400181: Stereo
   Pincap 0x0837: IN OUT Detect
   Pin Default 0x40000100: [N/A] Line Out at Ext N/A
     Conn = Unknown, Color = Unknown
   Pin-ctls: 0x00:
   Connection: 1
      0x03
Node 0x12 [Pin Complex] wcaps 0x400001: Stereo
   Pincap 0x0820: IN
   Pin Default 0x40000100: [N/A] Line Out at Ext N/A
     Conn = Unknown, Color = Unknown
   Pin-ctls: 0x00:
Node 0x13 [Pin Complex] wcaps 0x400001: Stereo
   Pincap 0x0820: IN
   Pin Default 0x40000100: [N/A] Line Out at Ext N/A
     Conn = Unknown, Color = Unknown
   Pin-ctls: 0x00:
Node 0x14 [Pin Complex] wcaps 0x400001: Stereo
   Pincap 0x0820: IN
   Pin Default 0x40000100: [N/A] Line Out at Ext N/A
     Conn = Unknown, Color = Unknown
   Pin-ctls: 0x00:
Node 0x15 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
   Amp-Out vals:  [0x00 0x00]
   Connection: 9
      0x0e 0x12 0x0f 0x0b* 0x0c 0x0d 0x0a 0x10 0x11
Node 0x16 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
   Amp-Out vals:  [0x00 0x00]
   Connection: 9
      0x0e* 0x12 0x0f 0x0b 0x0c 0x0d 0x0a 0x10 0x11
Node 0x17 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
   Amp-Out vals:  [0x00 0x00]
   Connection: 9
      0x0e* 0x12 0x0f 0x0b 0x0c 0x0d 0x0a 0x10 0x11
Node 0x18 [Audio Selector] wcaps 0x300103: Stereo Amp-In
   Amp-In caps: N/A
   Amp-In vals:  [0x00 0x00]
   Connection: 1
      0x15
Node 0x19 [Audio Selector] wcaps 0x300103: Stereo Amp-In
   Amp-In caps: N/A
   Amp-In vals:  [0x00 0x00]
   Connection: 1
      0x16
Node 0x1a [Audio Selector] wcaps 0x300103: Stereo Amp-In
   Amp-In caps: N/A
   Amp-In vals:  [0x00 0x00]
   Connection: 1
      0x17
Node 0x1b [Audio Selector] wcaps 0x30090d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Connection: 3
      0x18* 0x13 0x14
Node 0x1c [Audio Selector] wcaps 0x30090d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Connection: 3
      0x19* 0x13 0x14
Node 0x1d [Audio Selector] wcaps 0x30090d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Connection: 3
      0x1a* 0x13 0x14
Node 0x1e [Audio Output] wcaps 0x40211: Stereo Digital
   PCM:
     rates [0x7e0]: 44100 48000 88200 96000 176400 192000
     bits [0xe]: 16 20 24
     formats [0x5]: PCM AC3
Node 0x1f [Vendor Defined Widget] wcaps 0xf30201: Stereo Digital
Node 0x20 [Audio Input] wcaps 0x140311: Stereo Digital
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0xe]: 16 20 24
     formats [0x5]: PCM AC3
   Connection: 1
      0x22
Node 0x21 [Pin Complex] wcaps 0x400301: Stereo Digital
   Pincap 0x0810: OUT
   Pin Default 0x01442070: [Jack] SPDIF Out at Ext Rear
     Conn = RCA, Color = Grey
   Pin-ctls: 0x40: OUT
   Connection: 5
      0x1e* 0x1f 0x1b 0x1c 0x1d
Node 0x22 [Pin Complex] wcaps 0x430681: Stereo Digital
   Pincap 0x0810024: IN EAPD Detect
   Pin Default 0x40000100: [N/A] Line Out at Ext N/A
     Conn = Unknown, Color = Unknown
   Pin-ctls: 0x00:
   Power: 0x0
Node 0x23 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
   Amp-Out caps: ofs=0x03, nsteps=0x03, stepsize=0x17, mute=0
   Amp-Out vals:  [0x00]
Node 0x24 [Volume Knob Widget] wcaps 0x600000: Mono

