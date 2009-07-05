Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZGENVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZGENVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 09:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbZGENVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 09:21:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:37246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbZGENVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 09:21:36 -0400
Subject: Re: [tip:x86/cleanups] x86: Clean up mtrr/cleanup.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, jaswinderrajput@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <84144f020907050459x6a9a11fmf8f3050f085c8d85@mail.gmail.com>
References: <20090703164225.GA21447@elte.hu>
	 <tip-63f9600fadb10ea739108ae93e3e842d9843c58b@git.kernel.org>
	 <4A4FC5D0.6090000@kernel.org> <20090705002709.GA28424@elte.hu>
	 <1246773777.2325.113.camel@jaswinder.satnam>
	 <84144f020907050459x6a9a11fmf8f3050f085c8d85@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 05 Jul 2009 18:49:55 +0530
Message-Id: <1246799995.2442.7.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pekka,

On Sun, 2009-07-05 at 14:59 +0300, Pekka Enberg wrote:
> Hi Jaswinder,
> 
> On Sun, Jul 5, 2009 at 9:02 AM, Jaswinder Singh
> Rajput<jaswinder@kernel.org> wrote:
> > On Sun, 2009-07-05 at 02:27 +0200, Ingo Molnar wrote:
> >> * Yinghai Lu <yinghai@kernel.org> wrote:
> >>
> >> > >  static struct var_mtrr_range_state __initdata range_state[RANGE_NUM];
> >> > > +
> >> > >  static int __initdata debug_print;
> >> > > +#define Dprintk(x...) do { if (debug_print) printk(KERN_DEBUG x); } while (0)
> >> > > +
> >> > > +
> >> >
> >> > two blank lines?
> >>
> >> ah, yes - i moved them around.
> >>
> >> > > +#define BIOS_BUG_MSG KERN_WARNING \
> >> > > + "WARNING: BIOS bug: VAR MTRR %d contains strange UC entry under 1M, check with your system vendor!\n"
> >> >
> >> > No user for this
> >>
> >> yeah. Mind sending a patch for these? (and any other things you
> >> might notice)
> >>
> >
> > But why you did this stupidity.
> >
> > I clearly specified that these are trivial clean-ups, if you found any
> > issue in the patch you should ping me. Instead of adding crap from your
> > side.
> 
> What's with the attitude? It's perfectly okay for a commiter to change
> the patch as long as it's mentioned in the changelog. And that's
> usually much faster to do that for minor issues rather than ping the
> original submitter and wait for a resend.
> 

I was also thankful to him but then he send me a long email and blamed
me that I wasted his 6 hours to do further cleanup and solve bugs and
other irrelevant things. And told me to not send further patches
otherwise he will ignore it.

He is doing mistakes and blaming others and misusing maintainer-ship.

You still thinks it's perfectly okay.

Thanks,
--
JSR

