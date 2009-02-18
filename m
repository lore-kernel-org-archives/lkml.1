Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbZBRRYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbZBRRYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZBRRYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:24:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54109 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZBRRYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:24:41 -0500
Date: Wed, 18 Feb 2009 18:23:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove
	single ipi fallback for smp_call_function_many())
Message-ID: <20090218172349.GA14798@elte.hu>
References: <20090217214518.GA13189@redhat.com> <20090217223910.GM6761@linux.vnet.ibm.com> <20090218135212.GB23125@wotan.suse.de> <alpine.LFD.2.00.0902180744520.21686@localhost.localdomain> <20090218162116.GC29863@elte.hu> <alpine.LFD.2.00.0902180828430.21686@localhost.localdomain> <20090218165808.GA9120@elte.hu> <20090218170517.GA9769@elte.hu> <20090218171048.GA12299@elte.hu> <alpine.LFD.2.00.0902180915430.21686@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0902180915430.21686@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 18 Feb 2009, Ingo Molnar wrote:
> > 
> > ok, it's documented:
> > 
> >    Intel® 64 and IA-32 Architectures
> >    Software Developer’s Manual
> >                            Volume 3A:
> >        System Programming Guide, Part 1
> > 
> >  9.5.3        MSR Access in x2APIC Mode
> 
> Well, mine says
> 
> 	9.5.3 Error Handling
> 
> so I guess I need to download a newer version. After all, mine 
> is "ancient" in being a year old (the February-2008 version) 
> and not covering x2APIC at all.

Mine is 253668.pdf, that's the freshest available:

  http://download.intel.com/design/processor/manuals/253668.pdf

	Ingo
