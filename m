Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbYLHNZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbYLHNZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYLHNZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:25:10 -0500
Received: from smtp.nokia.com ([192.100.122.233]:40701 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbYLHNZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:25:09 -0500
Message-ID: <493D1F9D.5070307@yandex.ru>
Date: Mon, 08 Dec 2008 15:22:37 +0200
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nick Andrew <nick@nick-andrew.net>
CC: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org,
       apw@shadowen.org
Subject: Re: [PATCH 1/1] fs: fix warning message with inserting a single	space
References: <1228737252-31948-1-git-send-email-Hiroshi.DOYU@nokia.com> <20081208123517.GA3892@mail.local.tull.net> <493D1E15.6060001@yandex.ru>
In-Reply-To: <493D1E15.6060001@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Dec 2008 13:24:38.0077 (UTC) FILETIME=[51B72ED0:01C95938]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> Nick Andrew wrote:
>> On Mon, Dec 08, 2008 at 01:54:12PM +0200, Hiroshi DOYU wrote:
>>> -            printk(KERN_WARNING "%s: %s passed in a files array"
>>> +            printk(KERN_WARNING "%s: %s passed in a files array "
>>>                  "with an index of 1!\n", __func__,
>>>                  s->s_type->name);
>>
>> Yep. These look like the same kind of thing:
>>
>> arch/powerpc/platforms/cell/iommu.c +1109
>>                                 pr_debug("iommu: hash window doesn't 
>> fit in"
>>                                          "real DMA window\n");
> 
> Do we have such kind of check in checkpatch.pl? Would be useful.

Although I guess it is difficult to formalize this.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
