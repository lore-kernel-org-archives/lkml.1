Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYAEPGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYAEPGa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 10:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYAEPGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:06:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41776 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbYAEPGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:06:21 -0500
Date: Sat, 5 Jan 2008 16:05:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/7] sched: rt-group: per group period
Message-ID: <20080105150559.GA1192@elte.hu>
References: <20080104135457.336761000@chello.nl> <20080104135653.157876000@chello.nl> <1199544719.31975.34.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199544719.31975.34.camel@lappy>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Could you please fold this into the 6/7 patch.
> 
> It reverts a wandering chunk (the 32768 thing), but more importantly
> it fixes !FAIR_GROUP_SCHED compilation.

done. Btw., there's a new warning:

kernel/sched_rt.c:197: warning: 'rt_se_boosted' defined but not used

	Ingo
