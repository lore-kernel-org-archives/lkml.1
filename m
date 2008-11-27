Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYK0UsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYK0UsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 15:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYK0UsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 15:48:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40520 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbYK0UsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 15:48:06 -0500
Date: Thu, 27 Nov 2008 21:47:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: oops/warning report for the week of November 26, 2008
Message-ID: <20081127204714.GA25875@elte.hu>
References: <492DD792.6080302@linux.intel.com> <20081127115236.GE29013@elte.hu> <492EE087.80708@linux.intel.com> <20081127201836.GA16869@elte.hu> <20081127122800.45fc0b1a@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127122800.45fc0b1a@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> On Thu, 27 Nov 2008 21:18:36 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Arjan van de Ven <arjan@linux.intel.com> wrote:
> > 
> > > Ingo Molnar wrote:
> > >> * Arjan van de Ven <arjan@linux.intel.com> wrote:
> > >>
> > >>> Rank 8: mtrr_trim_uncached_memory (warning)
> > >>> 	Reported 227 times (619 total reports)
> > >>> 	There is a high number of machines where our MTRR checks
> > >>> 	trigger. I suspect we are too picky in accepting the MTRR
> > >>> 	configuration.
> > >>
> > >> the warning here means: "the BIOS messed up but we fixed it up for
> > >> you just fine".
> > >
> > > I don't believe that right now. we see so many of these, including 
> > > many "there's no MTRRs at all", that I am seriously suspecting that 
> > > our code is just incorrect somehow and triggering too much.
> > 
> > well we looked at existing reports and Linux was right to fix them
> > up. Show us one that is incorrect, then we can fix it up.
> > 
> > the "no MTRR's" are vmware/(also qemu?) guests not implementing a
> > full CPU emulation.
> 
> ... and it's still our fault in part, since we don't even check to 
> see if a cpu claims to support MTRR before complaining about it...
> 
> easy to fix though:

IIRC the problem is that vmware _does_ claim that it supports MTRRs. 

	Ingo
