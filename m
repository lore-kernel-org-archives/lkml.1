Return-Path: <linux-kernel-owner+w=401wt.eu-S1751393AbXAXNE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbXAXNE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 08:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXAXNE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 08:04:26 -0500
Received: from mail.first.fraunhofer.de ([194.95.169.2]:62375 "EHLO
	mail.first.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbXAXNEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 08:04:25 -0500
Subject: Re: 2.6.19.2 sky2/acpi crashes
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Stephen Hemminger <shemminger@osdl.org>
References: <1169542768.5537.11.camel@cocoduo>
%3cep4nb2%24mh2%241%40fortknox.intranet.wo.rk%3e: 
%3cf4527be0701230312q2a22b41i93abdf8972525d9e%40mail.gmail.com%3e: 
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Jan 2007 14:04:11 +0100
Message-Id: <1169643852.29990.11.camel@localhost>
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[This mail was also posted to newsgate.kernel.]

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
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
