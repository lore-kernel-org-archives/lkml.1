Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbXDTBaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbXDTBaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 21:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbXDTBaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 21:30:30 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753888AbXDTBa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 21:30:29 -0400
Date: Thu, 19 Apr 2007 18:27:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ed Tomlinson <edt@aei.ca>
cc: Mark Lord <lkml@rtr.ca>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Renice X for cpu schedulers
In-Reply-To: <200704192117.38428.edt@aei.ca>
Message-ID: <alpine.LFD.0.98.0704191824090.9964@woody.linux-foundation.org>
References: <20070417062621.GL2986@holomorphy.com> <200704200110.47974.kernel@kolivas.org>
 <46279585.4010409@rtr.ca> <200704192117.38428.edt@aei.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Apr 2007, Ed Tomlinson wrote:
> > 
> > SD just doesn't do nearly as good as the stock scheduler, or CFS, here.
> > 
> > I'm quite likely one of the few single-CPU/non-HT testers of this stuff.
> > If it should ever get more widely used I think we'd hear a lot more complaints.
> 
> amd64 UP here.  SD with several makes running works just fine.

The thing is, it probably depends *heavily* on just how much work the X 
server ends up doing. Fast video hardware? The X server doesn't need to 
busy-wait much. Not a lot of eye-candy? The X server is likely fast enough 
even with a slower card that it still gets sufficient CPU time and isn't 
getting dinged by any balancing. DRI vs non-DRI? Which window manager 
(maybe some of the user-visible lags come from there..) etc etc.

Anyway, I'd ask people to look a bit at the current *regressions* instead 
of spending all their time on something that won't even be merged before 
2.6.21 is released, and we thus have some mroe pressing issues. Please?

			Linus
