Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbXDDPsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbXDDPsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933566AbXDDPsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:48:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47218 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbXDDPsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:48:09 -0400
Date: Wed, 4 Apr 2007 17:46:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 04/17] Add pagetable accessors to pack and unpack pagetable entries
Message-ID: <20070404154655.GA31804@elte.hu>
References: <20070402055652.610711908@goop.org> <20070402055704.278590661@goop.org> <200704020812.18320.ak@suse.de> <46136F25.7030907@goop.org> <20070404095745.GA16726@elte.hu> <4613C7AB.5020509@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4613C7AB.5020509@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
> > the main metric we are interested in is the overhead for people who just 
> > want to run the non-patched native kernel that has CONFIG_PARAVIRT 
> > enabled (99%+ of the users at the moment), so the delta is:
> >
> >  null:              +12.0%
> >  null IO:            +7.5%
> >  stat:        within noise
> >  open/close:  within noise
> >  TCP:                ~5.0%
> >  signal install:      2.0%
> >  signal handle:       4.7%
> >  fork:                2.7%
> >  exec:                3.6%
> >  shell:               3.6%
> >   
>
> Hm, I don't think you can get this much precision out of these 
> numbers. I noticed larger variations from boot-to-boot running the 
> same test.

sure. i simply took the middle numbers. But there's definitely a 'few 
percents' trend in the numbers.

> > this is not 'barely measurable' but 'BLOODY LARGE' overhead.
> 
> Yes.  Fortunately there's a noticable difference between native and 
> unpatched paravirt, because it shows all the effort we put into 
> patching is worthwhile.

if only it were not such an ugly piece of code? ;)

	Ingo
