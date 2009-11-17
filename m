Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZKQQSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZKQQSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZKQQSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:18:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:39316 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbZKQQSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:18:10 -0500
Message-ID: <4B02CC4B.9060800@kernel.org>
Date: Wed, 18 Nov 2009 01:16:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, peterz@infradead.org,
       andi@firstfloor.org, Andi Kleen <ak@linux.intel.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 01/21] workqueue: fix race condition in	schedule_on_each_cpu()
References: <1258391726-30264-1-git-send-email-tj@kernel.org> <1258391726-30264-2-git-send-email-tj@kernel.org> <20091116230427.GD5293@nowhere> <4B024B18.40604@redhat.com>
In-Reply-To: <4B024B18.40604@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11/17/2009 04:04 PM, Avi Kivity wrote:
>> Shouldn't this patch go to .32 ?
>> This looks like an important fix.
> 
> Is anything using preeempt notifier on affected architectures?

Checking... yeap, ia64 has both __ARCH_WANT_UNLOCKED_CTXSW and KVM.

-- 
tejun
