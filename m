Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbZISIBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbZISIBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 04:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbZISIBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 04:01:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34447 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbZISIBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 04:01:21 -0400
Date: Sat, 19 Sep 2009 10:01:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: sebastien cabaniols <sebastien.cabaniols@hp.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: performance counter for linux question.
Message-ID: <20090919080114.GA7676@elte.hu>
References: <200909171428.23610.sebastien.cabaniols@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909171428.23610.sebastien.cabaniols@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2041]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* sebastien cabaniols <sebastien.cabaniols@hp.com> wrote:

> Hello list,
> 
> I am interested by monitoring instructions versus cycles with a Nehalem box 
> using 2.6.31 with PCL.
> 
> Is there a way with perf report to display both counters ?
> 
> I used
> 
> perf record -e cycles -e instructions -a  for the recording session.
> 
> perf report -n seems to be doing what I need but for only one counter.
> 
> Is this a limitation of perf report ? 
> Is this an architectural limitation of PCL ?
> Is there more documentation than what is in the perf directory in the 2.6.31 
> tarball ?

You can find a description and a tutorial here:

  http://lwn.net/Articles/339361/

There's also http://perf.wiki.kernel.org.

	Ingo
