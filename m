Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbZJAJ1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbZJAJ1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZJAJ1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:27:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbZJAJ1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:27:00 -0400
Message-ID: <4AC474F2.7070600@redhat.com>
Date: Thu, 01 Oct 2009 11:22:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed	workqueue
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <20091001084040.GA15345@elte.hu> <4AC4725E.3070509@redhat.com>
In-Reply-To: <4AC4725E.3070509@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 11:11 AM, Avi Kivity wrote:
>
> In fact I've thought of implementing threadlets and 
> concurrency-managed workqueues with preempt notifiers ;)

Oh, and use them to make kernel_fpu_begin() preemptible.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

