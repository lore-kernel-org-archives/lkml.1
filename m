Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbXKSSwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbXKSSwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXKSSwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:52:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37630 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbXKSSwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:52:44 -0500
Date: Mon, 19 Nov 2007 19:52:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: andersen@codepoet.org, linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3,
	v2.6.23.8, v2.6.22.13, v2.6.21.7
Message-ID: <20071119185237.GA10965@elte.hu>
References: <20071119151756.GA25446@elte.hu> <20071119181207.GA11900@codepoet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119181207.GA11900@codepoet.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Erik Andersen <andersen@codepoet.org> wrote:

> On Mon Nov 19, 2007 at 04:17:56PM +0100, Ingo Molnar wrote:
> > 
> > By popular demand, here is release -v24 of the CFS scheduler patch.
> > 
> > It is a full backport of the latest & greatest scheduler code to 
> > v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7. The patches can be 
> > downloaded from the usual place:
> > 
> >     http://people.redhat.com/mingo/cfs-scheduler/
> 
> Doesn't compile with 2.6.21.7:

does the patch below help?

	Ingo

Index: linux-cfs-2.6.21.7.q/include/linux/sched.h
===================================================================
--- linux-cfs-2.6.21.7.q.orig/include/linux/sched.h
+++ linux-cfs-2.6.21.7.q/include/linux/sched.h
@@ -10,7 +10,7 @@
 #define COMPAT_REGISTER_SYSCTL
 
 /* backporting helper macro: */
-#define cpu_sibling_map(cpu) per_cpu(cpu_sibling_map, cpu)
+#define cpu_sibling_map(cpu) cpu_sibling_map[cpu]
 
 /*
  * cloning flags:

