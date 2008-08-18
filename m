Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbYHRGwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbYHRGwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 02:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYHRGwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 02:52:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47809 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbYHRGwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 02:52:38 -0400
Date: Mon, 18 Aug 2008 08:52:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: a.p.zijlstra@chello.nl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: scale sysctl_sched_shares_ratelimit with nr_cpus
Message-ID: <20080818065220.GA2711@elte.hu>
References: <37E52D09333DE2469A03574C88DBF40F024EBD2F@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37E52D09333DE2469A03574C88DBF40F024EBD2F@pdsmsx414.ccr.corp.intel.com>
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


* Zhang, Yanmin <yanmin.zhang@intel.com> wrote:

> Ingo,
> 
> My linux mailbox is locked, so I send from my another mail box.
> 
> I tested the patch of scale sysctl_sched_shares_ratelimit with nr_cpus 
> on 16-core tigerton by volanoMark. CONFIG_GROUP_SCHED=y. Comparing 
> with pure 2.6.27-rc3, the patched kernel has about 15% improvement, 
> and it seems volanoMark runs more smoothly with the patched kernel.

cool. It's already upstream (post-rc3 commit):

  55cd534: sched: scale sysctl_sched_shares_ratelimit with nr_cpus

	Ingo
