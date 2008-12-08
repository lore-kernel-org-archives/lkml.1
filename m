Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbYLHNSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbYLHNSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYLHNSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:18:24 -0500
Received: from smtp.nokia.com ([192.100.105.134]:23083 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYLHNSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:18:23 -0500
Message-ID: <493D1E15.6060001@yandex.ru>
Date: Mon, 08 Dec 2008 15:16:05 +0200
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nick Andrew <nick@nick-andrew.net>
CC: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org,
       apw@shadowen.org
Subject: Re: [PATCH 1/1] fs: fix warning message with inserting a single	space
References: <1228737252-31948-1-git-send-email-Hiroshi.DOYU@nokia.com> <20081208123517.GA3892@mail.local.tull.net>
In-Reply-To: <20081208123517.GA3892@mail.local.tull.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Dec 2008 13:18:05.0524 (UTC) FILETIME=[67BC5940:01C95937]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Andrew wrote:
> On Mon, Dec 08, 2008 at 01:54:12PM +0200, Hiroshi DOYU wrote:
>> -			printk(KERN_WARNING "%s: %s passed in a files array"
>> +			printk(KERN_WARNING "%s: %s passed in a files array "
>>  				"with an index of 1!\n", __func__,
>>  				s->s_type->name);
> 
> Yep. These look like the same kind of thing:
> 
> arch/powerpc/platforms/cell/iommu.c +1109
>                                 pr_debug("iommu: hash window doesn't fit in"
>                                          "real DMA window\n");

Do we have such kind of check in checkpatch.pl? Would be useful.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
