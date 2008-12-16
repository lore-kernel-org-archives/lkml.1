Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbYLPLQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbYLPLQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYLPLPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:15:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38534 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbYLPLPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:15:45 -0500
Date: Tue, 16 Dec 2008 12:15:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] cpuacct: refactoring cpuusage_read / cpuusage_write
Message-ID: <20081216111526.GC4299@elte.hu>
References: <b040c32a0812152202y4914ba88gbf0c9137d50a296a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0812152202y4914ba88gbf0c9137d50a296a@mail.gmail.com>
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


* Ken Chen <kenchen@google.com> wrote:

> In the thread regarding to 'export percpu cpuacct cgroup stats'
> http://lkml.org/lkml/2008/12/7/13
> 
> akpm pointed out that current cpuacct code is inefficient.  This patch
> refactoring the following:
> 
> * make cpu_rq locking only on 32-bit
> * change iterator to each_present_cpu instead of each_possible_cpu to
>   make it hotplug friendly.
> 
> It's a bit of code churn, but I was rewarded with 160 byte code size saving
> on x86-64 arch and zero code size change on i386.

applied to tip/sched/core, thanks Ken!

	Ingo
