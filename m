Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYINNaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYINNaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 09:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYINNaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 09:30:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44058 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbYINNaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 09:30:12 -0400
Date: Sun, 14 Sep 2008 15:29:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, arjan@linux.intel.com,
       tglx@linutronix.de, hpa@zytor.com, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct
Message-ID: <20080914132952.GC554@elte.hu>
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080913000051.819383000@linux-os.sc.intel.com> <48CBF25B.5030107@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CBF25B.5030107@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Venkatesh Pallipadi wrote:
> > From: Suresh Siddha <suresh.b.siddha@intel.com>
> > Subject: [patch 1/2] x86: track memtype for RAM in page struct
> >
> > Track the memtype for RAM pages in page struct instead of using the memtype
> > list. This avoids the explosion in the number of entries in memtype list
> > (of the order of 20,000 with AGP) and makes the PAT tracking simpler. We are
> > using PG_arch_1 bit in page->flags.
> >   
> 
> Please define PG_arch_1 a proper name so that its easy to tell its 
> being used just by looking at page-flags.h.

it should be defined in include/asm-x86/page.h though, not in 
page-flags.h - other architectures are using this flag for other 
purposes.

	Ingo
