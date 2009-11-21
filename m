Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZKUMIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZKUMIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 07:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZKUMIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 07:08:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:59007 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZKUMIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 07:08:47 -0500
Subject: Re: [PATCHSET] workqueue: prepare for concurrency managed
 workqueue, take#2
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net
In-Reply-To: <4B07608B.7020002@kernel.org>
References: <1258692407-8985-1-git-send-email-tj@kernel.org>
	 <4B07608B.7020002@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Nov 2009 13:07:59 +0100
Message-ID: <1258805279.4104.923.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-21 at 12:37 +0900, Tejun Heo wrote:
> Hello,
> 
> 11/20/2009 01:46 PM, Tejun Heo wrote:
> > 0001-sched-kvm-fix-race-condition-involving-sched_in_pree.patch
> > 0002-workqueue-Add-debugobjects-support.patch
> > 0003-sched-rename-preempt_notifier-to-sched_notifier-and-.patch
> > 0004-sched-update-sched_notifier-and-add-wakeup-sleep-not.patch
> > 0005-sched-implement-sched_notifier_wake_up_process.patch
> > 0006-scheduler-implement-force_cpus_allowed.patch
> > 0007-acpi-use-queue_work_on-instead-of-binding-workqueue-.patch
> > 0008-stop_machine-reimplement-without-using-workqueue.patch
> > 0009-workqueue-misc-cosmetic-updates.patch
> > 0010-workqueue-merge-feature-parametesr-into-flags.patch
> > 0011-workqueue-update-cwq-alignement-and-make-one-more-fl.patch
> > 0012-workqueue-define-both-bit-position-and-mask-for-work.patch
> > 0013-workqueue-separate-out-process_one_work.patch
> > 0014-workqueue-temporarily-disable-workqueue-tracing.patch
> 
> I'm pushing out 0001-0014 to linux-next via the following tree.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-next
> 
> I intend to keep the tree stable from this point on unless drastic
> change is necessary.  I'll posting further patches against the above
> tree.

05 is a full nak and needs reimplementing.
06 at the very least needs a changelog.

