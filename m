Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZKUDjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZKUDjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 22:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbZKUDjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 22:39:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:39465 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbZKUDjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 22:39:10 -0500
Message-ID: <4B07608B.7020002@kernel.org>
Date: Sat, 21 Nov 2009 12:37:47 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, peterz@infradead.org, johannes@sipsolutions.net
Subject: Re: [PATCHSET] workqueue: prepare for concurrency managed workqueue,
 take#2
References: <1258692407-8985-1-git-send-email-tj@kernel.org>
In-Reply-To: <1258692407-8985-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/20/2009 01:46 PM, Tejun Heo wrote:
> 0001-sched-kvm-fix-race-condition-involving-sched_in_pree.patch
> 0002-workqueue-Add-debugobjects-support.patch
> 0003-sched-rename-preempt_notifier-to-sched_notifier-and-.patch
> 0004-sched-update-sched_notifier-and-add-wakeup-sleep-not.patch
> 0005-sched-implement-sched_notifier_wake_up_process.patch
> 0006-scheduler-implement-force_cpus_allowed.patch
> 0007-acpi-use-queue_work_on-instead-of-binding-workqueue-.patch
> 0008-stop_machine-reimplement-without-using-workqueue.patch
> 0009-workqueue-misc-cosmetic-updates.patch
> 0010-workqueue-merge-feature-parametesr-into-flags.patch
> 0011-workqueue-update-cwq-alignement-and-make-one-more-fl.patch
> 0012-workqueue-define-both-bit-position-and-mask-for-work.patch
> 0013-workqueue-separate-out-process_one_work.patch
> 0014-workqueue-temporarily-disable-workqueue-tracing.patch

I'm pushing out 0001-0014 to linux-next via the following tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-next

I intend to keep the tree stable from this point on unless drastic
change is necessary.  I'll posting further patches against the above
tree.

Thank you.

-- 
tejun
