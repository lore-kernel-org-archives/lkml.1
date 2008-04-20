Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbYDTGLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbYDTGLo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 02:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750706AbYDTGLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 02:11:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48639 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYDTGLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 02:11:33 -0400
Date: Sat, 19 Apr 2008 23:11:10 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080419231110.59d95410@laptopd505.fenrus.org>
In-Reply-To: <480AAC20.4050604@sandeen.net>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080418142934.38ce6bf4.akpm@linux-foundation.org>
	<20080419142329.GA5339@elte.hu>
	<20080419145948.GA4528@lintop>
	<20080419110034.34b70bd5@laptopd505.fenrus.org>
	<480AAC20.4050604@sandeen.net>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008 21:36:16 -0500
Eric Sandeen <sandeen@sandeen.net> wrote:


> > For 1), we need to know which they are, and then solve them,
> > because even on x86-64 with 8k stacks they can be a problem (just
> > because the stack frames are bigger, although not quite double,
> > there).
> 
> Except, apparently, not, at least in my experience.

if you actually go over on x86, it's not unlikely that you're getting close to the edge on 64 bit.

At minimum we really do want to fix these things...

> I've personally never seen common stack problems with xfs on x86_64,
> but it's very common on x86.  I don't have a great answer for why, but
> that's my anecdotal evidence.

One thing I've learned with the kerneloops.org work is that people don't read
their dmesg..... 
> 
> > I've not seen any recent reports, I'll try to extend the
> > kerneloops.org client to collect the "stack is getting low" warning
> > to be able to see how much this really happens.
> 
> That sounds like a very good thing to collect, and maybe if I re-send
> a "clearly state stack overflows at oops time" patch you can easily
> keep tabs.

... which makes me think we need to strengthen this part of the kernel.
(and then have kerneloops.org collect the issues)

If there's a clear pattern in the backtraces we will find it. 
And then we can fix it... which is absolutely the right thing,
I don't think anyone disagrees with that.

So yes if you can dig up your patch, yes please!


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
