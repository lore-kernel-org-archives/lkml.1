Return-Path: <linux-kernel-owner+w=401wt.eu-S1764835AbYA2Rs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764835AbYA2Rs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbYA2RsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:48:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45878 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbYA2RsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:48:12 -0500
Date: Tue, 29 Jan 2008 18:47:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: fix overlap between pagetable with bss section
Message-ID: <20080129174755.GA28549@elte.hu>
References: <200801281844.36940.yinghai.lu@sun.com> <20080129174242.GA26562@elte.hu> <200801291003.14741.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801291003.14741.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> > > +	/* need to round it up to avoid overlap less one page */
> > > +	table_start = round_up(table_start, PAGE_SIZE);
> > >  	table_start >>= PAGE_SHIFT;
> > >  	table_end = table_start;
> > 
> > thanks, applied.
> 
> can you use v2 instead? v2 have more comments.

yes, i have v2.

	Ingo
