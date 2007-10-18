Return-Path: <linux-kernel-owner+w=401wt.eu-S933013AbXJRIt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbXJRIt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 04:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932524AbXJRItt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 04:49:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:50486 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932520AbXJRIts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 04:49:48 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX1+HuuFL3JaHHhyziPqw97UWQ0wdCQpICNugstJgPD
	G7TjkpuJV/cJGc
From: Jan-Simon =?iso-8859-15?q?M=F6ller?= <dl9pf@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: hda-intel: no soundcard with current linus' git tree
Date: Thu, 18 Oct 2007 10:49:48 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
References: <471538C2.80806@m3y3r.de> <4716C68C.4030504@garzik.org>
In-Reply-To: <4716C68C.4030504@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181049.48896.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've also no sound. Had it working using the alsa.git tree _before_ the last 
merge (>48h). Needed to use model=asus for this fujitsu v5505 here.

Now it doesn't work, even with other model-options (fujitsu, laptop). 


legolas:/proc/asound # cat cards
 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xfc400000 irq 22
legolas:/proc/asound # cat pcm
00-01: Conexant Digital : Conexant Digital : playback 1
00-00: CONEXANT Analog : CONEXANT Analog : playback 1 : capture 1
legolas:/proc/asound # cat hwdep
00-00: HDA Codec 0
legolas:/proc/asound # cat devices
  2:        : timer
  3: [ 0- 1]: digital audio playback
  4: [ 0- 0]: digital audio playback
  5: [ 0- 0]: digital audio capture
  6: [ 0- 0]: hardware dependent
  7: [ 0]   : control
  8:        : sequencer

legolas:/proc/asound # cat card0/codec#0
Codec: Conexant CX20549 (Venice)
Address: 0
Vendor Id: 0x14f15045
Subsystem Id: 0x1734110e
Revision Id: 0x100100
No Modem Function Group found
Default PCM:
    rates [0x140]: 48000 96000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
Node 0x10 [Pin Complex] wcaps 0x40058d: Stereo Amp-Out
  Amp-Out caps: ofs=0x2b, nsteps=0x2b, stepsize=0x05, mute=1
  Amp-Out vals:  [0x2b 0x2b]
  Pincap 0x0810014: OUT EAPD Detect
  Pin Default 0x92170110: [Fixed] Speaker at Int Front
    Conn = Analog, Color = Unknown
  Pin-ctls: 0x40: OUT
  Power: 0x0
  Connection: 2
     0x19 0x17*
Node 0x11 [Pin Complex] wcaps 0x40058d: Stereo Amp-Out
  Amp-Out caps: ofs=0x2b, nsteps=0x2b, stepsize=0x05, mute=1
  Amp-Out vals:  [0x2b 0x2b]
  Pincap 0x08113c: IN OUT HP Detect
  Pin Default 0x0121401f: [Jack] HP Out at Ext Rear
    Conn = 1/8, Color = Green
  Pin-ctls: 0xc0: OUT HP
  Power: 0x0
  Connection: 2
     0x19 0x17*
Node 0x12 [Pin Complex] wcaps 0x40058d: Stereo Amp-Out
  Amp-Out caps: ofs=0x2b, nsteps=0x2b, stepsize=0x05, mute=1
  Amp-Out vals:  [0x2b 0x2b]
  Pincap 0x08113c: IN OUT HP Detect
  Pin Default 0x01a19020: [Jack] Mic at Ext Rear
    Conn = 1/8, Color = Pink
  Pin-ctls: 0x20: IN
  Power: 0x0
  Connection: 2
     0x19 0x17*
Node 0x13 [Pin Complex] wcaps 0x400301: Stereo Digital
  Pincap 0x0810: OUT
  Pin Default 0x214571f0: [Jack] SPDIF Out at Sep Rear
    Conn = Optical, Color = Yellow
  Pin-ctls: 0x00:
  Connection: 1
     0x18
Node 0x14 [Pin Complex] wcaps 0x400081: Stereo
  Pincap 0x081124: IN Detect
  Pin Default 0x97a7012e: [Fixed] Mic at Int Riser
    Conn = Analog, Color = Unknown
  Pin-ctls: 0x24: IN
Node 0x15 [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x0820: IN
  Pin Default 0x400001f0: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
  Pin-ctls: 0x00:
Node 0x16 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Amp-Out caps: ofs=0x07, nsteps=0x07, stepsize=0x0b, mute=1
  Amp-Out vals:  [0x06]
Node 0x17 [Audio Mixer] wcaps 0x20050b: Stereo Amp-In
  Amp-In caps: ofs=0x14, nsteps=0x2b, stepsize=0x05, mute=1
  Amp-In vals:  [0x94 0x94] [0x94 0x94] [0x94 0x94] [0x94 0x94] [0x94 0x94]
  Power: 0x0
  Connection: 5
     0x19 0x14 0x12 0x11 0x15
Node 0x18 [Audio Output] wcaps 0x211: Stereo Digital
  PCM:
    rates [0x40]: 48000
    bits [0x6]: 16 20
    formats [0x5]: PCM AC3
Node 0x19 [Audio Output] wcaps 0xc11: Stereo
  PCM:
    rates [0x540]: 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Power: 0x0
Node 0x1a [Audio Input] wcaps 0x100d0b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x17, stepsize=0x05, mute=1
  Amp-In vals:  [0x17 0x17] [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00]
  Power: 0x0
  Connection: 5
     0x17 0x14* 0x12 0x11 0x15
Node 0x1b [Vendor Defined Widget] wcaps 0xf00000: Mono

Best regards
Jan-Simon
