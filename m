Return-Path: <linux-kernel-owner+w=401wt.eu-S1764703AbYCDNQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764703AbYCDNQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 08:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758284AbYCDNQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 08:16:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45087 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759379AbYCDNQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 08:16:41 -0500
Date: Tue, 4 Mar 2008 14:16:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alexey Starikovskiy <aystarik@gmail.com>,
       lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080304131600.GG29777@elte.hu>
References: <20080303091714.GA18250@elte.hu> <20080303093103.GA23651@uranus.ravnborg.org> <20080303103933.GC21190@elte.hu> <20080303113451.GF4457@cs181133002.pp.htv.fi> <20080303114533.GA4183@elte.hu> <20080303120211.GG4457@cs181133002.pp.htv.fi> <20080303121015.GA12660@elte.hu> <20080303122953.GH4457@cs181133002.pp.htv.fi> <20080303125027.GA21577@elte.hu> <20080303145413.GA26072@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303145413.GA26072@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@stusta.de> wrote:

> > well, i'm trying to assume the best, so please explain the following 
> > sequence of events to me:
> > 
> > 1) as you said you knew about this bug - which bug causes more inlining
> >    overhead than hundreds of your uninlining patches combined. The bug
> >    was introduced ~2 years ago in -mm - before the feature hit mainline
> >    in v2.6.16.
> 
> I don't remember having ever said this.
> 
> Your choices are:
> [ ] prove your accusation that I said I
>     "knew about this bug before the feature hit mainline"
> [ ] apologize
> [ ] be the firest person ever in my killfile

Adrian, you must be misunderstanding something. Where exactly in the 
above sentences do i assert that you "knew about this bug before the 
feature hit mainline"? I dont say that and cannot say that - and it's 
rather irrelevant. All i say is that you knew about this bug for a long 
time.

> >...
> > still, while you clearly had interest in this general area of the kernel 
> > (for example you wrote hundreds of tiny uninlining patches that work 
> > towards a similar goal),
> 
> I'm not sure with whom you confuse me on this one.
> Perhaps with Ilpo?

i mean you send tons of trivial patches along the lines of:

|  Author: Adrian Bunk <bunk@kernel.org>
|  Date:   Fri Feb 22 21:58:37 2008 +0200
|
|    x86: don't make swapper_pg_pmd global

to reduce size of the kernel. At 50 bytes of image savings a pop, the 
127,000 bytes savings my patch gives would be equivalent to more than 
2500 of such patches of yours.

In other words: you knew about a bug that would have the same kernel 
image size reduction equivalent to 2500 of your own tiny patches. Still 
you didnt feel the need to pursue the issue?

I'm not sure about you, but that sure looks weird to me, and i'm really 
curious what your interpretation of it is. (which, AFAICS, you have not 
offered so far. You have rejected my common-sense explanation of your 
actions rather forcefully, so logically there must be some other 
explanation.)

	Ingo
