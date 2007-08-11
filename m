Return-Path: <linux-kernel-owner+w=401wt.eu-S1761013AbXHKR5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013AbXHKR5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 13:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbXHKR5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 13:57:13 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:41060 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754191AbXHKR5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 13:57:12 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: sb-400 audigy prob
Date: Sat, 11 Aug 2007 18:57:01 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200708111258.43546.gene.heskett@gmail.com>
In-Reply-To: <200708111258.43546.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708111857.01355.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 August 2007 17:58:43 Gene Heskett wrote:
> Greetings;
>
> Running 23-rc2 since it came out, I've just discovered I have only the
> system beep for sound. From lspci:
> 01:08.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
>         Subsystem: Creative Labs Unknown device 1001
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32 (500ns min, 5000ns max)
>         Interrupt: pin A routed to IRQ 12
>         Region 0: I/O ports at c000 [size=64]
>         Capabilities: [dc] Power Management version 2
>                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> But I have a line in my rc.local that reloads the sound fonts:
> [root@coyote rulesdujour]# sfxload /usr/music/SoundFonts/CT4MGM.SF2
> No AWE synth device is found

I'm not 100% sure, but (at least) Debian has two programs "sfxload" 
and "asfxload", which work with OSS and ALSA respectively. I've found that 
both can work, but the former will only work with OSS emulation loaded. If 
you have an "asfxload", I would try it instead.

> This occurred once before and a reboot fixed it, so I'm going to try it
> again. BRB
>
> About 4 reboots later, it finally works again, after it had hung in udev,
> and apparently did an auto reboot while I was looking for my flashlight.  I
> had selected in that case to boot to 2.6.22-rt9 since 2.6.23-rc1 didn't
> work either and udev had hung after spitting out that useless screenfull of
> missing attributes messages like it always does, (when do we get rid of
> that?) and it had been hung in udev for about 3 minutes before I got up and
> left to find my flashlight.  On arrival with light in hand, I found the
> same screenfull of udev messages and assumed it was still hung, but as I
> was crawling under the desk I heard the speakers thump like they do when
> udev finds the device, and the boot continued.  I didn't realize it had
> spontainiously rebooted till I saw the login message said 2.6.23-rc2, the
> grub default.

Not that it explains any of this, of course. I hope you can reproduce it.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

