Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYFIT7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYFIT7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbYFIT7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:59:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:8073 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbYFIT7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=iTgbFbvrzppJKhy4mJit9av8gRZoXpBAYRvd2J3H7TTBvEg0ySx6fDxDqmcSwYRdBf
         kEjT/LYZNlTtWUyV4Tmma2yh5fucdQCsw19gkQOI61iQpjztkcYmEJaYFRnShpvRY8Zo
         U0LflopcHWTl0kDQ7l155EGOapBUiMyJEzEp8=
Message-ID: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
Date: Mon, 9 Jun 2008 20:59:00 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: ALC883 recording troubles...
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi-san,

I'm experiencing DC offset with the microphone on 2.6.24 (Ubuntu 8.04
LTS x86-64). I can see on Audacity that the DC offset that varies with
the recording capture level. Plus, the mixer playback->mic-boost
muting enables/disables mic-boost in recording.

It feels like the ALC883 pins aren't configured quite right. The mobo
is an Asus P5E-VM with current BIOS [1]

What's the routine to debug this? Would it help to install windows,
dump the register space and compare?

Thanks in advance,
  Daniel

--- [1]

$ sudo lspci -vvvxxxs 0:1b.0
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 02)
	Subsystem: ASUSTeK Computer Inc. Unknown device 829f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at fe9f8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express Unknown type IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
		Link: Latency L0s <64ns, L1 <1us
		Link: ASPM Disabled CommClk- ExtSynch-
		Link: Speed unknown, Width x0
00: 86 80 3e 29 06 00 10 00 02 00 03 04 08 00 00 00
10: 04 80 9f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 9f 82
30: 00 00 00 00 50 00 00 00 00 00 00 00 0f 01 00 00
40: 01 00 00 07 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 60 42 c8 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 70 80 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 10 00 91 00 00 00 00 10 00 08 10 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 04 00 01 00 00 00 00 31 00 a3 02 00 00 00 00
d0: 61 00 a3 02 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00

$ aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC883 Analog [ALC883 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 1: ALC883 Digital [ALC883 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 3: ATI HDMI [ATI HDMI]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 2: HDMI [HDA ATI HDMI], device 3: ATI HDMI [ATI HDMI]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
daniel@veyron:~$ aplay -L
default:CARD=Intel
    HDA Intel, ALC883 Analog
    Default Audio Device
front:CARD=Intel,DEV=0
    HDA Intel, ALC883 Analog
    Front speakers
surround40:CARD=Intel,DEV=0
    HDA Intel, ALC883 Analog
    4.0 Surround output to Front and Rear speakers
surround41:CARD=Intel,DEV=0
    HDA Intel, ALC883 Analog
    4.1 Surround output to Front, Rear and Subwoofer speakers
surround50:CARD=Intel,DEV=0
    HDA Intel, ALC883 Analog
    5.0 Surround output to Front, Center and Rear speakers
surround51:CARD=Intel,DEV=0
    HDA Intel, ALC883 Analog
    5.1 Surround output to Front, Center, Rear and Subwoofer speakers
surround71:CARD=Intel,DEV=0
    HDA Intel, ALC883 Analog
    7.1 Surround output to Front, Center, Side, Rear and Woofer speakers
null
    Discard all samples (playback) or generate zero samples (capture)
default:CARD=U0x46d0x990
    USB Device 0x46d:0x990, USB Audio
    Default Audio Device
front:CARD=U0x46d0x990,DEV=0
    USB Device 0x46d:0x990, USB Audio
    Front speakers
surround40:CARD=U0x46d0x990,DEV=0
    USB Device 0x46d:0x990, USB Audio
    4.0 Surround output to Front and Rear speakers
surround41:CARD=U0x46d0x990,DEV=0
    USB Device 0x46d:0x990, USB Audio
    4.1 Surround output to Front, Rear and Subwoofer speakers
surround50:CARD=U0x46d0x990,DEV=0
    USB Device 0x46d:0x990, USB Audio
    5.0 Surround output to Front, Center and Rear speakers
surround51:CARD=U0x46d0x990,DEV=0
    USB Device 0x46d:0x990, USB Audio
    5.1 Surround output to Front, Center, Rear and Subwoofer speakers
surround71:CARD=U0x46d0x990,DEV=0
    USB Device 0x46d:0x990, USB Audio
    7.1 Surround output to Front, Center, Side, Rear and Woofer speakers
iec958:CARD=U0x46d0x990,DEV=0
    USB Device 0x46d:0x990, USB Audio
    IEC958 (S/PDIF) Digital Audio Output
front:CARD=HDMI
    HDA ATI HDMI
    Front speakers
surround40:CARD=HDMI
    HDA ATI HDMI
    4.0 Surround output to Front and Rear speakers
surround41:CARD=HDMI
    HDA ATI HDMI
    4.1 Surround output to Front, Rear and Subwoofer speakers
surround50:CARD=HDMI
    HDA ATI HDMI
    5.0 Surround output to Front, Center and Rear speakers
surround51:CARD=HDMI
    HDA ATI HDMI
    5.1 Surround output to Front, Center, Rear and Subwoofer speakers
surround71:CARD=HDMI
    HDA ATI HDMI
    7.1 Surround output to Front, Center, Side, Rear and Woofer speakers
-- 
Daniel J Blueman
