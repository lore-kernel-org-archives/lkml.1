Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbYAGLRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbYAGLRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYAGLRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:17:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40963 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbYAGLRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:17:39 -0500
Date: Mon, 7 Jan 2008 12:17:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/11] another rt group sched update
Message-ID: <20080107111717.GA29973@elte.hu>
References: <20080106161128.152634000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080106161128.152634000@chello.nl>
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

> this time compile tested on all 16 combinations of:
> 
>   CONFIG_SMP
>   CONFIG_FAIR_GROUP_SCHED
>   CONFIG_HIGH_RES_TIMERS
>   CONFIG_NO_HZ
> 
> ran some but not all combinations

thanks, applied. This is a really big step forwards in terms of making 
RT task CPU usage more flexible and more manageable.

	Ingo
