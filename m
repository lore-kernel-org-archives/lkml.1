Return-Path: <linux-kernel-owner+w=401wt.eu-S965985AbXFFXLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965985AbXFFXLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965074AbXFFXKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:10:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36081 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964911AbXFFXKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:10:51 -0400
Date: Thu, 7 Jun 2007 01:10:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Peschke <mp3@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, jbaron@redhat.com,
       rostedt@goodmis.org, linux-s390@vger.kernel.org
Subject: Re: [RFC] [Patch 4/4] lock contention tracking slimmed down
Message-ID: <20070606231041.GB11592@elte.hu>
References: <1181165656.7133.23.camel@dix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181165656.7133.23.camel@dix>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Peschke <mp3@de.ibm.com> wrote:

> - lock_time_inc() vs. statistic_add_util()

please fix the coding style in lib/statistic.c. It's full of:

{
        unsigned long long i;
        if (value <= stat->u.histogram.range_min)
                return 0;

put a newline after variable sections.

and:

        on_each_cpu(_statistic_barrier, NULL, 0, 1);
        return 0;

preferably use a newline before 'return' statements as well. (this is 
not always necessary, but in the above case it looks better)

	Ingo
