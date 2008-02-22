Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbYBVJlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbYBVJlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYBVJk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:40:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49549 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbYBVJkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:40:55 -0500
Date: Fri, 22 Feb 2008 10:40:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peter@programming.kicks-ass.net>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Remove duplicate code from sched_fair.c
Message-ID: <20080222094038.GH327@elte.hu>
References: <20080222075553.GA3691@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222075553.GA3691@balbir.in.ibm.com>
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> yield_task_fair has some duplicate code, that can be replaced with 
> rb_last(). This code reuses rb_next and removes the duplicate code. As 
> a side effect, we don't do an rb_entry for each node as we walk along 
> the path.

thanks, applied.

	Ingo
