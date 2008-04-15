Return-Path: <linux-kernel-owner+w=401wt.eu-S1764597AbYDOFuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764597AbYDOFuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 01:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYDOFuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 01:50:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34369 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081AbYDOFuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 01:50:07 -0400
Date: Tue, 15 Apr 2008 07:49:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: travis@sgi.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at
	mm/slab.c:2103!"
Message-ID: <20080415054939.GB7420@elte.hu>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <Pine.LNX.4.64.0804111223380.20334@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804111223380.20334@schroedinger.engr.sgi.com>
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


* Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 11 Apr 2008, Pekka Enberg wrote:
> 
> > slab bug and I don't see any recent changes to the page allocator
> > either that would explain this.
> 
> I also have an internal report that x86-git causes boot to fail with 
> an 8p if one starts with a x86_64 config file and then converts to 
> x86_32. Somehow the NR_CPUS is set to 255 in that case. Could this 
> exhaust memory? I guess the per cpu cleanup work may figure in that 
> area. Mike?

how about reading my bugreport that you replied to:

   http://lkml.org/lkml/2008/4/11/34

It gives an answer to your question, trivially so. It includes an easy 
link to the very config that failed:

   http://redhat.com/~mingo/misc/config-Thu_Apr_10_10_41_16_CEST_2008.bad

which would tell you:

   CONFIG_NR_CPUS=8

so no, it's not 255 CPUs exhausing RAM ...

	Ingo
