Return-Path: <linux-kernel-owner+w=401wt.eu-S1761076AbYHELVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076AbYHELVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758758AbYHELUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:20:14 -0400
Received: from as1.cineca.com ([130.186.84.213]:40388 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760702AbYHELUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:20:10 -0400
Message-ID: <48981D3B.2020701@gmail.com>
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>
Cc: "'Ryo Tsuruta'" <ryov@valinux.co.jp>, ngupta@google.com, vtaras@openvz.org,
       "'Dave Hansen'" <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org
Subject: Re: Too many I/O controller patches
References: <20080804.175126.193692178.ryov@valinux.co.jp> <1217870433.20260.101.camel@nimitz> <489748E6.5080106@gmail.com> <000901c8f6a5$fe64ba30$fb2e2e90$@jp.nec.com>
In-Reply-To: <000901c8f6a5$fe64ba30$fb2e2e90$@jp.nec.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Date: Tue,  5 Aug 2008 11:28:27 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Satoshi UCHIDA wrote:
>  Andrea's requirement is
>    * to be able to set and control by absolute(direct) performance.

     * improve IO performance predictability of each cgroup
       (try to guarantee more precise IO performance values)

> And, he gave a advice "Can't a framework which organized each way,
> such as I/O elevator, be made?".
> I try to consider such framework (in elevator layer or block layer).

It would be probably the best place to evaluate the "cost" of each
IO operation.

> I think that OOM problems caused by memory/cache systems.
> So, it will be better that I/O controller created out of these problems
> first, although a lateness of the I/O device would be related.
> If these problem can be resolved, its technique should be applied into 
> normal I/O control as well as cgroups.
> 
> Buffered write I/O is also related with cache system.
> We must consider this problem as I/O control.

Agree. At least, maybe we should consider if an IO controller could be
a valid solution also for these problems.

>> I did some experiments trying to implement minimum bandwidth requirements
>> for my io-throttle controller, mapping the requirements to CFQ prio and
>> using the Satoshi's controller. But this needs additional work and
>> testing right now, so I've not posted anything yet, just informed
>> Satoshi about this.
> 
> I'm very interested in this results.

I'll collect some numbers and keep you informed.

-Andrea
