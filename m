Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbXLCVrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbXLCVrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbXLCVrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:47:18 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38696 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751296AbXLCVrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:47:16 -0500
Date: Mon, 3 Dec 2007 22:47:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Timers SMP] can this machine be helped?
Message-ID: <20071203214756.GB8704@elf.ucw.cz>
References: <Pine.LNX.4.64.0711292144260.6673@axis700.grange> <20071202183048.GC4721@ucw.cz> <Pine.LNX.4.64.0712032242540.7783@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712032242540.7783@axis700.grange>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-12-03 22:45:06, Guennadi Liakhovetski wrote:
> On Sun, 2 Dec 2007, Pavel Machek wrote:
> 
> > > I compiled a .24-ish kernel for it with CONFIG_NO_HZ and 
> > > CONFIG_HIGH_RES_TIMERS. To get the system boot at least sometimes I have 
> > > to specify nohz=off. Then I get
> > 
> > Try highres=off, too... Hehe, and even idle=poll might help.
> 
> Ok, for now I've compiled a kernel with all "advanced" features off like 
> hrt, nohz. Will see how it behaves. But thanks for the hints.

Let us know...

> > > CR0: 8005003b CR2: 081dcf88 CR3: 07e46000 CR4: 000002d0
> > > DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > > DR6: ffff0ff0 DR7: 00000400
> > >  [<c01053fa>] show_trace_log_lvl+0x1a/0x30
> > >  [<c0105f42>] show_trace+0x12/0x20
> > 
> > ...and disable softlockup watchdog, too...
> 
> So, you think those BUGs are bogus?

Well.... you want to make old machine usable, right? Disabling
warnings is fair game.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
