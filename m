Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbXLCV5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbXLCV5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXLCV5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:57:08 -0500
Received: from mail.gmx.net ([213.165.64.20]:60290 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750723AbXLCV5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:57:07 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18HoSpQmh4HBcKf6VZgSkNS37p0QR2auduWdTle0Y
	wb0XESaHMiJjTi
Date: Mon, 3 Dec 2007 22:56:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: [Timers SMP] can this machine be helped?
In-Reply-To: <20071203214756.GB8704@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0712032255430.7783@axis700.grange>
References: <Pine.LNX.4.64.0711292144260.6673@axis700.grange>
 <20071202183048.GC4721@ucw.cz> <Pine.LNX.4.64.0712032242540.7783@axis700.grange>
 <20071203214756.GB8704@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007, Pavel Machek wrote:

> On Mon 2007-12-03 22:45:06, Guennadi Liakhovetski wrote:
> > On Sun, 2 Dec 2007, Pavel Machek wrote:
> 
> > > > CR0: 8005003b CR2: 081dcf88 CR3: 07e46000 CR4: 000002d0
> > > > DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > > > DR6: ffff0ff0 DR7: 00000400
> > > >  [<c01053fa>] show_trace_log_lvl+0x1a/0x30
> > > >  [<c0105f42>] show_trace+0x12/0x20
> > > 
> > > ...and disable softlockup watchdog, too...
> > 
> > So, you think those BUGs are bogus?
> 
> Well.... you want to make old machine usable, right? Disabling
> warnings is fair game.

Ouch, but not if a CPU __really__ gets stuck for 13 seconds...

Thanks
Guennadi
---
Guennadi Liakhovetski
