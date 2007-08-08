Return-Path: <linux-kernel-owner+w=401wt.eu-S933888AbXHHWr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbXHHWr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbXHHWrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:47:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:51911 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756245AbXHHWrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:47:17 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+001cfYze0l41boVcWITAAtHqMnKfYMASvX/Mgc6
	Ha65rduHQxi0jv
Date: Thu, 9 Aug 2007 00:47:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Oncaphillis <oncaphillis@snafu.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: UART misbehaves under Linkstation/KuroBoxHG
In-Reply-To: <46BA3DF5.4050201@snafu.de>
Message-ID: <Pine.LNX.4.60.0708090041160.6767@poirot.grange>
References: <46B9CE82.1050000@snafu.de> <Pine.LNX.4.60.0708082219520.6767@poirot.grange>
 <46BA320E.1030608@snafu.de> <Pine.LNX.4.60.0708082323420.6767@poirot.grange>
 <46BA3DF5.4050201@snafu.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Oncaphillis wrote:
> 
>   I hope I found the the misconfigured part. I didn't look
>   at /etc/inittab. It opens a getty on /dev/ttyS0. That
>   might do the trick. Have to recompile my kernel right now with
>   standard config to check this out.

Hm, for that you don't have to recompile the kernel... unless you modified 
it before, of course. Just change your inittab and reboot.

>   Well ... it doesn't seem to need the daemons but at least
>   the kuro_boot  script or something similar has to be executed
>   once sending the right init strings to the AVR or your system
>   reboots after a few minutes at least on my box.

No, shouldn't be needed either. You should get a string in dmesg like 
"linkstation: disarming the AVR watchdog:", and the watchdog should be 
off. Just take the original .dts, unmodified kernel sources and close 
enough to original (arch/powerpc/configs/linkstation_defconfig) .config 
and it should work.

Thanks
Guennadi
---
Guennadi Liakhovetski
