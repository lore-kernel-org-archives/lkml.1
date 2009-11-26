Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbZKZJtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbZKZJtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759679AbZKZJtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:49:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:44510 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759675AbZKZJtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:49:22 -0500
Message-ID: <4B0E4EFB.2070705@kernel.org>
Date: Thu, 26 Nov 2009 18:48:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the workqueues tree with the tip
 tree
References: <20091126190018.88a6dd77.sfr@canb.auug.org.au> <20091126081237.GA31034@elte.hu> <4B0E4741.10509@kernel.org> <20091126092631.GA17253@elte.hu>
In-Reply-To: <20091126092631.GA17253@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

11/26/2009 06:26 PM, Ingo Molnar wrote:
>> Sure, which sched/* branch should I base these patches on?
> 
> You could send the patch you rely on standalone (it seems to be a single 
> patch) and we can look at applying it to the scheduler tree. That 
> reduces the conflicts on an ongoing basis. Please Cc: PeterZ and Mike 
> Galbraith as well.

The tree contains four scheduler patches.

0001-sched-rename-preempt_notifier-to-sched_notifier-and-.patch
0002-sched-update-sched_notifier-and-add-wakeup-sleep-not.patch
0003-sched-implement-sched_notifier_wake_up_process.patch
0004-sched-implement-force_cpus_allowed.patch

1, 2 and 4 are somewhat spread throughout sched.c so it would be
better if they all are routed through sched tree.  Currently the
wq#for-sched contains the followings on top of linus#master.

* Adds debugobj support to workqueue.

* Pulls in sched/urgent to receive the scheduler fix.

* Adds the above four patches.

If pulling in from the existing branch is an option, I'd prefer that.
If not, please let me know.  I'll send the above four patches against
sched/urgent.

Thanks.

-- 
tejun
