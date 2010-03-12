Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150Ab0CLFBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 00:01:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:58655 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab0CLFBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 00:01:18 -0500
Message-ID: <4B99CB0F.1090505@kernel.org>
Date: Fri, 12 Mar 2010 14:03:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org, oleg@redhat.com
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#4
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <29029.1268232771@redhat.com>
In-Reply-To: <29029.1268232771@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Mar 2010 05:00:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/10/2010 11:52 PM, David Howells wrote:
>  * queue_work - queue work on a workqueue
>  * @wq: workqueue to use
>  * @work: work to queue
>  *
>  * Returns 0 if @work was already on a queue, non-zero otherwise.
>  *
>  * We queue the work to the CPU on which it was submitted, but if the CPU dies
>  * it can be processed by another CPU.
> 
> So when a work item is running on a CPU, any work items it queues (including
> requeueing itself) will be queued upon that CPU for attention only by that CPU
> (assuming that CPU doesn't get pulled out)?

Yes, that's the one of the characteristics of workqueue.  For IO bound
stuff, it usually is a plus.

Thanks.

-- 
tejun
