Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbZIXTna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbZIXTna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbZIXTn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:43:29 -0400
Received: from mx06.lb01.inode.at ([62.99.145.6]:11537 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753875AbZIXTn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:43:28 -0400
X-Greylist: delayed 751 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 15:43:28 EDT
Message-ID: <4ABBCBE1.9030805@sbg.ac.at>
Date: Thu, 24 Sep 2009 21:43:29 +0200
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.23 (X11/20090826)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
References: <4ABBB8C2.2080901@sbg.ac.at> <200909242124.42187.elendil@planet.nl> <200909242140.10174.elendil@planet.nl>
In-Reply-To: <200909242140.10174.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Thursday 24 September 2009, Frans Pop wrote:
>   
>>> error message from .31:
>>>  [157152.418524] irq 23: nobody cared
>>>       
>> If no others reply and the issue can be reproduced reliably, running a
>> git bisect between v2.6.29 and v2.6.30 to trace the cause of the
>> regression could be an option.
>>     
>
> Looking at the changes in drivers/ata/ahci.c, it might be worth to try if 
> reverting the following commit fixes the issue:
>
> commit a5bfc4714b3f01365aef89a92673f2ceb1ccf246
> Author: Tejun Heo <tj@kernel.org>
> Date:   Fri Jan 23 11:31:39 2009 +0900
>
>     ahci: drop intx manipulation on msi enable
>
> It's a bit of a wild guess though.
>   
thanks for the hint.
i'll wait for the end of the compilation of gcc-4.3.4. that will take ~ 45m.
afterwards i'll check out the kernel sources from git and try the revert.
many thanks till then.

-alex
