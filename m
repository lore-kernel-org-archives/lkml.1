Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZKQFO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZKQFO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 00:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZKQFOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 00:14:25 -0500
Received: from ozlabs.org ([203.10.76.45]:58488 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbZKQFOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 00:14:25 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/21] scheduler: implement force_cpus_allowed_ptr()
Date: Tue, 17 Nov 2009 15:44:25 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
References: <1258391726-30264-1-git-send-email-tj@kernel.org> <1258391726-30264-9-git-send-email-tj@kernel.org>
In-Reply-To: <1258391726-30264-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911171544.25355.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 03:45:13 am Tejun Heo wrote:
> Implement force_cpus_allowed_ptr() which is similar to
> set_cpus_allowed_ptr() but bypasses PF_THREAD_BOUND check and ignores
> cpu_active() status as long as the target cpu is online.  This will be
> used for concurrency-managed workqueue.

Can we drop the silly _ptr() postfix?  It was a hack someone added to
avoid churning set_cpus_allowed(), and no need to repeat here.

Thanks,
Rusty.
