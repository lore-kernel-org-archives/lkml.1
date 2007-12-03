Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbXLCVpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbXLCVpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbXLCVox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:44:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:48783 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750764AbXLCVow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:44:52 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+ExNFmpA+EnH/vsff3Yd7omm4FepBH0Q4KGVErGx
	Q1ZCd/9Ob0AMJh
Date: Mon, 3 Dec 2007 22:45:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: [Timers SMP] can this machine be helped?
In-Reply-To: <20071202183048.GC4721@ucw.cz>
Message-ID: <Pine.LNX.4.64.0712032242540.7783@axis700.grange>
References: <Pine.LNX.4.64.0711292144260.6673@axis700.grange>
 <20071202183048.GC4721@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2007, Pavel Machek wrote:

> > I compiled a .24-ish kernel for it with CONFIG_NO_HZ and 
> > CONFIG_HIGH_RES_TIMERS. To get the system boot at least sometimes I have 
> > to specify nohz=off. Then I get
> 
> Try highres=off, too... Hehe, and even idle=poll might help.

Ok, for now I've compiled a kernel with all "advanced" features off like 
hrt, nohz. Will see how it behaves. But thanks for the hints.

> > Pid: 0, comm: swapper Not tainted (2.6.24-rc2-g8c086340 #3)
> > EIP: 0060:[<c0233d33>] EFLAGS: 00000283 CPU: 0
> > EIP is at acpi_processor_idle+0x2ae/0x477
> > EAX: 00000000 EBX: fffffeab ECX: 00000001 EDX: 00000001
> > ESI: c7c5f2d0 EDI: 00122d9f EBP: c03ddfa8 ESP: c03ddf90
> >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > CR0: 8005003b CR2: 081dcf88 CR3: 07e46000 CR4: 000002d0
> > DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > DR6: ffff0ff0 DR7: 00000400
> >  [<c01053fa>] show_trace_log_lvl+0x1a/0x30
> >  [<c0105f42>] show_trace+0x12/0x20
> 
> ...and disable softlockup watchdog, too...

So, you think those BUGs are bogus?

Thanks
Guennadi
---
Guennadi Liakhovetski
