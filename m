Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbZGCH3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbZGCH3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZGCH3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:29:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57073 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZGCH3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:29:47 -0400
Date: Fri, 3 Jul 2009 09:29:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
	kernel modules
Message-ID: <20090703072941.GC7943@elte.hu>
References: <1246514639.13293.40.camel@marge.simson.net> <20090702064712.GA26690@elte.hu> <1246519076.6384.22.camel@marge.simson.net> <1246524170.7113.20.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246524170.7113.20.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Thu, 2009-07-02 at 09:17 +0200, Mike Galbraith wrote:
> 
> > After I resurrect (well, try) live annotation in top...
> 
> Random thought wrt live top annotation: instead of resurrecting in 
> the previous form, which could be a bit intrusive display space 
> wise, what do you think of this idea?
> 
> Provide a kbd input snapshot trigger which builds a perf record 
> (hard?) compatible file for the symbols being displayed.  Start a 
> background task to annotate the lot, stuffing annotate output into 
> an output file.
> 
> Better ideas highly welcome.

Hm, is there really a performance problem?

We need to calculate and cache the objdump annotation output once, 
but after that it should be pretty fast as we just display updated 
counts with the same lines over and over again. No repeated objdump 
runs are needed.

	Ingo
