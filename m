Return-Path: <linux-kernel-owner+w=401wt.eu-S1422667AbXCGJfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422667AbXCGJfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422670AbXCGJfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:35:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43629 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422667AbXCGJfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:35:30 -0500
Date: Wed, 7 Mar 2007 10:35:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bill Irwin <bill.irwin@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307093518.GB8424@elte.hu>
References: <20070221023656.6306.246.sendpatchset@linux.site> <20070221023735.6306.83373.sendpatchset@linux.site> <20070306225101.f393632c.akpm@linux-foundation.org> <20070307070853.GB15877@wotan.suse.de> <20070307081948.GA9563@wotan.suse.de> <20070307082755.GA25733@elte.hu> <20070307085944.GA17433@wotan.suse.de> <20070307092252.GA6499@elte.hu> <20070307093208.GK18774@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307093208.GK18774@holomorphy.com>
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


* Bill Irwin <bill.irwin@oracle.com> wrote:

> * Nick Piggin <npiggin@suse.de> wrote:
> >> After these patches, I don't think there is too much burden. The main 
> >> thing left really is just the objrmap stuff, but that is just handled 
> >> with a minimal 'dumb' algorithm that doesn't cost much.
> 
> On Wed, Mar 07, 2007 at 10:22:52AM +0100, Ingo Molnar wrote:
> > ok. What do you think about the sys_remap_file_pages_prot() thing that 
> > Paolo has done in a nicely split up form - does that complicate things 
> > in any fundamental way? That is what is useful to UML.
> 
> Oracle would love it. You don't want to know how far back I've been 
> asked to backport that.

ok, cool! Then the first step would be for you to talk to Paolo and to 
pick up the patches, review them, nurse it in -mm, etc. Suffering in 
silence is just a pointless act of masochism, not an efficient 
upstream-merge tactic ;-)

	Ingo
