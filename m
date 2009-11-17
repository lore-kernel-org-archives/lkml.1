Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZKQFTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZKQFTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 00:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZKQFTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 00:19:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:42080 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbZKQFTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 00:19:40 -0500
Message-ID: <4B023275.5000506@kernel.org>
Date: Tue, 17 Nov 2009 14:19:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
Subject: Re: [PATCH 08/21] scheduler: implement force_cpus_allowed_ptr()
References: <1258391726-30264-1-git-send-email-tj@kernel.org> <1258391726-30264-9-git-send-email-tj@kernel.org> <200911171544.25355.rusty@rustcorp.com.au>
In-Reply-To: <200911171544.25355.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11/17/2009 02:14 PM, Rusty Russell wrote:
> On Tue, 17 Nov 2009 03:45:13 am Tejun Heo wrote:
>> Implement force_cpus_allowed_ptr() which is similar to
>> set_cpus_allowed_ptr() but bypasses PF_THREAD_BOUND check and ignores
>> cpu_active() status as long as the target cpu is online.  This will be
>> used for concurrency-managed workqueue.
> 
> Can we drop the silly _ptr() postfix?  It was a hack someone added to
> avoid churning set_cpus_allowed(), and no need to repeat here.

Yeah, it's an ugly name.  I'll drop it from the new function.

Thanks.

-- 
tejun
