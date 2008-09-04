Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbYIDLJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbYIDLJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYIDLJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:09:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYIDLJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:09:17 -0400
Date: Thu, 4 Sep 2008 13:09:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
Message-ID: <20080904110901.GD8668@elte.hu>
References: <1220518266.9590.22.camel@minggr> <1220519034.8609.206.camel@twins> <1220525579.12161.8.camel@minggr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220525579.12161.8.camel@minggr>
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


* Lin Ming <ming.m.lin@intel.com> wrote:

> I observed schedstats of sysbench, there's more
> "nr_failed_migrations_hot"
> 
> 2.6.27-rc4: se.nr_failed_migrations_hot 11
> 2.6.27-rc5: se.nr_failed_migrations_hot 95
> 
> task migration failed because of task_hot, the system is un-balanced?

would be nice to get a representative (==steady state) scheduler trace 
from the critical portions of that workload. See:

 http://people.redhat.com/mingo/sched-devel.git/readme-tracer.txt

	Ingo
