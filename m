Return-Path: <linux-kernel-owner+w=401wt.eu-S1751384AbXAXNCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbXAXNCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 08:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXAXNCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 08:02:49 -0500
Received: from mail.first.fraunhofer.de ([194.95.169.2]:55214 "EHLO
	mail.first.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbXAXNCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 08:02:48 -0500
To: linux-kernel@vger.kernel.org
Date: Wed, 24 Jan 2007 13:02:42 +0000 (UTC)
From: Soeren Sonnenburg <kernel@nn7.de>
Message-ID: <ep7ldh$gsm$1@fortknox.intranet.wo.rk>
Organization: Local Intranet News
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
References: <1169542768.5537.11.camel@cocoduo>
Subject: Re: 2.6.19.2 sky2/acpi crashes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 11:12:50 +0000, Andrew Lyon wrote:

> On 1/23/07, Soeren Sonnenburg <kernel@nn7.de> wrote:
>> On Tue, 23 Jan 2007 08:59:28 +0000, Lionel Landwerlin wrote:
>>
>> > Hi,
>> >
>> > I'm running a macbook with a Marvell ethernet controller, and I have a
>> > lots of freezes when using the ethernet controller under a load of
>> > ~100K/s. Since I'm running a 2.6.19.2 kernel, I'm able to get some
>> > report from the kernel. Here they are :
>>
>> I am also having trouble with the sky2 module, though I've not yet seen a
>> oops, the driver stopped working after some heavy traffic (copying some G
>> of data). Only rmmod sky2; modprobe sky2 resolved this. (I am also on
>> 2.6.19.2 but I've seen this happen on 2.6.20-rcX too).

[...]
> Ive also had the same problem with both 2.6.19.2 and 2.6.20-rcX,
> motherboard is gigabyte ga-965-ds3 , the networking stops completely
> under moderate traffic, I get the following errors or a complete
> lockup:
> 
> Jan 21 02:08:04 beast NETDEV WATCHDOG: eth0: transmit timed out
> Jan 21 02:08:04 beast sky2 eth0: tx timeout
> Jan 21 02:08:04 beast sky2 eth0: transmit ring 475 .. 452 report=475 done=475
> Jan 21 02:08:04 beast sky2 hardware hung? flushing
> 
> At the time I was downloading a iso image at 850k/sec, so not really a
> high network load at all.
> 
> rmmod / modprobe does resolve the issue, but more times than not the
> box locks up completely instead of getting those errors.

I am on a completely different system (macbook pro 1,1) with PREEMPT and
cpu frequency scaling on not sure how this could be related...

Soeren
