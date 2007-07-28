Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbXG1ElS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbXG1ElS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 00:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbXG1ElG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 00:41:06 -0400
Received: from [212.12.190.9] ([212.12.190.9]:33282 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751010AbXG1ElG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 00:41:06 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT 0/5] Input locking patches
Date: Sat, 28 Jul 2007 07:41:13 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707280741.13129.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
> On Tue, July 24, 2007 06:45, Dmitry Torokhov wrote:
> > Hi everyone,
> >
> > I finally managed to put together some patches implementing
> > locking in input core and main input handles. Please look
> > over them and give them a spin.
>
> Since kernel 2.6.21 or so I was annoyed by a warping mouse, and
> one kernel version later also by "stuck" keys, causing repeated input
> at the most inconvenient moments (e.g. when opening a program by
> pressing F1).
>
> As it happened irregularly and unpredictable it was hard to debug,
> and I suspected faulty hardware. My cpu was quite hot, but after
> removing all the dust it seems all right again. Unfortunately that
> was about the same time I upgraded to 2.6.23-rc1, so all I can say
> is that the stuck key problem seems to be gone, though not sure
> thanks to what, but that neither the cleaning nor the upgrade fixed
> the warping mouse problem.
>
> I'm running with these locking patches for two days now and the
> mouse doesn't warp any more (it can also have fixed the stuck key
> problem, not sure). Normally it would warp several times a day,
> and that didn't happen yet, so I'm tempted to praise your patches.
>
> Sorry for the babbling, just wanted to say that I've tested these
> patches and that they seem to fix real problems.

Thanks for babbling!

I'm having these same intermittent problems starting around 2.6.21, and 
wasn't really sure if it was hardware or not, so didn't bother reporting 
them.  This is what I see sometimes in the logs:

=====================================
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input3
input: AT Translated Set 2 keyboard as /class/input/input4
input: ImPS/2 Generic Wheel Mouse as /class/input/input5
psmouse.c: bad data from KBC - bad parity
psmouse.c: Wheel Mouse at isa0060/serio1/input0 lost synchronization, 
throwing 2 bytes away.
=====================================

Thanks!

--
Al
 
