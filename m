Return-Path: <linux-kernel-owner+w=401wt.eu-S1760734AbXKIDRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbXKIDRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 22:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbXKIDQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 22:16:56 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:63327 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXKIDQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 22:16:55 -0500
Message-ID: <4733D13A.6010305@codemonkey.ws>
Date: Thu, 08 Nov 2007 21:17:14 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: dor.laor@qumranet.com
CC: ron minnich <rminnich@gmail.com>, linux-kernel@vger.kernel.org,
       lguest <lguest@ozlabs.org>, virtualization@lists.linux-foundation.org
Subject: Re: [Lguest] [PATCH] virtio config_ops refactoring
References: <4730A8F3.6020008@us.ibm.com><200711081320.35844.rusty__6233.15023626692$1194488552$gmane$org@rustcorp.com.au><4732774C.6020903@codemonkey.ws><200711090924.28659.rusty@rustcorp.com.au><47338EA0.6050100@codemonkey.ws> <13426df10711081447o688550a4jc01be2d7f06209e0@mail.gmail.com> <4733A6F5.3040202@qumranet.com>
In-Reply-To: <4733A6F5.3040202@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dor Laor wrote:
> ron minnich wrote:
>>
>> Hi, I'm sorry, I've been stuck on other things (NFS RDMA anyone?) and
>> missed part of this discussion.
>>
>> Is it really the case that operations on virtio devices will involve
>> outl/inl etc.?
>>
> What's the problem with them?
> Except for the kick event it's not performance critical and the 
> difference between pio vmexit
> and hypercall exit is very small.

If you're a nutty guy who's interesting in creating the most absolute 
minimal VMM to run exotic paravirtual guests on massive clusters, then 
requiring PIO implies that you have to have an instruction decoder which 
is goes against the earlier goal ;-)

Regards,

Anthony Liguori

> I don't know about problems in other architectures, maybe mmio is better?
> Dor.
>>
>>
>> Apologies in advance for my failure to pay attention.
>>
>> thanks
>>
>> ron
>> _______________________________________________
>> Lguest mailing list
>> Lguest@ozlabs.org
>> https://ozlabs.org/mailman/listinfo/lguest
>>
>

