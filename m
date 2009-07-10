Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbZGJQIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbZGJQIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 12:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZGJQI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:08:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34817 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbZGJQIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:08:25 -0400
Date: Fri, 10 Jul 2009 18:08:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Boot Consoles question...
Message-ID: <20090710160809.GA22049@elte.hu>
References: <200907040017.26921.rgetz@blackfin.uclinux.org> <200907071949.41311.rgetz@blackfin.uclinux.org> <20090710102857.GF5499@elte.hu> <200907101028.03153.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907101028.03153.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> On Fri 10 Jul 2009 06:28, Ingo Molnar pondered:
> > 
> > * Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > 
> > > On Sat 4 Jul 2009 12:07, Robin Getz pondered:
> > > > On Sat 4 Jul 2009 06:29, Ingo Molnar pondered:
> > > > > Could be changed i guess ... but is it really an issue?
> > > > 
> > > > It is just a change from "normal" (when the kernel has no boot
> > > > console).
> > > > 
> > > > >  One artifact 
> > > > >  could be manual scroll-back - it would perhaps be nice indeed to
> > > > >  allow the scrollback to the top of the bootlog.
> > > > 
> > > > Exactly.
> > > > 
> > > > One of my thoughts (was since CON_PRINTBUFFER isn't used after 
> > > > register_console()) - was for the CON_BOOT's CON_PRINTBUFFER flag to
> > > > control the clearing of the CON_PRINTBUFFER for the real console or
> > > > not... 
> > > > 
> > > > All early_printk consoles that I looked at have their
> > > > CON_PRINTBUFFER set.
> > > > 
> > > > Which means that something like should do the trick -- allow people
> > > > who want 
> > > > to override things to do so, and still have the today's setup work
> > > > as is...
> > > 
> > > I guess no one liked that idea?
> > 
> > No, this means no-one objected :)
> 
> Silence is consensus?

No - silence is 'no objections expressed'. That doesnt make a change 
agreed on, it makes a change "not objected to so far" ;-) It could 
still be wrong, the onus is on you and me to make sure that isnt the 
case.

	Ingo
