Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbXJCJfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbXJCJfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 05:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXJCJfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 05:35:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51349 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793AbXJCJf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 05:35:29 -0400
Date: Wed, 3 Oct 2007 11:35:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
       menage@google.com, linux-kernel@vger.kernel.org, dino@in.ibm.com,
       cpw@sgi.com
Subject: Re: [patch] sched: fix sched-domains partitioning by cpusets
Message-ID: <20071003093517.GA22558@elte.hu>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <20071003062240.GA19027@elte.hu> <20071002235615.6e8cd007.pj@sgi.com> <200710030146.30162.nickpiggin@yahoo.com.au> <20071003022108.5a8e310e.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003022108.5a8e310e.pj@sgi.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Jackson <pj@sgi.com> wrote:

> There might be an even simpler way.  If the kernel/sched.c routines 
> detach_destroy_domains() and build_sched_domains() were exposed as 
> external routines, then the cpuset code could call them directly, 
> removing the partition_sched_domains() routine from sched.c entirely. 
> Would this be worth persuing?

in any case i'd like to see the externally visible API get in foremost - 
and there now seems to be agreement about that. (yay!) Any internal 
shaping of APIs can be done flexibly between cpusets and the scheduler.

	Ingo
