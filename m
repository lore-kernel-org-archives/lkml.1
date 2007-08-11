Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbXHKQ7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbXHKQ7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 12:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbXHKQ7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 12:59:23 -0400
Received: from ag-out-0708.google.com ([72.14.246.244]:11391 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbXHKQ7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 12:59:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=cgfttFq3nhD4EA3sUshio7+a4HmqQ3VrDzmnH0tvPmyvW7aRel3pajm75Rl6zQL/BSebGLy2NmGwQKRa8yHvWugDHgz5SartfvEWrd6njFdl43ls6IAu0gWiJrMapgbV9L1MG1Yk0nja9DPLw0gY+k2vA69t2uLAD2jR1jlq/i0=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: linux-kernel@vger.kernel.org
Subject: sb-400 audigy prob
Date: Sat, 11 Aug 2007 12:58:43 -0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708111258.43546.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Running 23-rc2 since it came out, I've just discovered I have only the system 
beep for sound. From lspci:
01:08.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
        Subsystem: Creative Labs Unknown device 1001
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (500ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 12
        Region 0: I/O ports at c000 [size=64]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

But I have a line in my rc.local that reloads the sound fonts:
[root@coyote rulesdujour]# sfxload /usr/music/SoundFonts/CT4MGM.SF2
No AWE synth device is found

This occurred once before and a reboot fixed it, so I'm going to try it again. 
BRB

About 4 reboots later, it finally works again, after it had hung in udev, and 
apparently did an auto reboot while I was looking for my flashlight.  I had 
selected in that case to boot to 2.6.22-rt9 since 2.6.23-rc1 didn't work 
either and udev had hung after spitting out that useless screenfull of 
missing attributes messages like it always does, (when do we get rid of 
that?) and it had been hung in udev for about 3 minutes before I got up and 
left to find my flashlight.  On arrival with light in hand, I found the same 
screenfull of udev messages and assumed it was still hung, but as I was 
crawling under the desk I heard the speakers thump like they do when udev 
finds the device, and the boot continued.  I didn't realize it had 
spontainiously rebooted till I saw the login message said 2.6.23-rc2, the 
grub default.

Hints gratefully checked out here folks.

Thanks

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I don't wanna argue, and I don't wanna fight,
But there will definitely be a party tonight...
