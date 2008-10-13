Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbYJMOAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbYJMOAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYJMN7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:59:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:39856 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbYJMN7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:59:54 -0400
Message-ID: <48F352DE.8060001@kernel.org>
Date: Mon, 13 Oct 2008 22:53:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_of_platform: fix no irq handling
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru> <48F2F138.6020103@kernel.org> <48F34CB9.3020000@pobox.com>
In-Reply-To: <48F34CB9.3020000@pobox.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Oct 2008 13:55:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> Anton Vorontsov wrote:
>>> When no irq specified the pata_of_platform fills the irq_res with -1,
>>> which is wrong to do for two reasons:
>>>
>>> 1. By definition, 'no irq' should be IRQ 0, not some negative integer;
>>> 2. pata_platform checks for irq_res.start > 0, but since irq_res.start
>>>    is unsigned type, the check will be true for `-1'.
>>>
>>> Reported-by: Steven A. Falco <sfalco@harris.com>
>>> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
>>
>> applied to #tj-upstream (will soon be sent upstream)
> 
> I have returned!  muhahahahahaha....

Ah.. great.  Hope you enjoyed the vacation.  Can you please pull from
#tj-upstream?

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata-dev.git tj-upstream
 http://git.kernel.org/?p=linux/kernel/git/tj/libata-dev.git;a=shortlog;h=tj-upstream

Nothing much.  Rafael's skip-spin-off patchset + Elias's small fix +
ATA_HORKAGE_ATAPI_MOD16_DMA + pata_of_platform irq fix.

Gwendal posted patches to enable FIS based switching when NCQ is
disabled on sata_mv but I think this should be put into separate
branch and stay in linux-next till Mark Lord comes back and reviews it
as I don't know much about the driver and don't know of anyone other
than Gwendal and Mark who do.

sata_nv detection problem is still not resolved.  I figured out
generic and ck804 but nf2/3 is still malfunctioning.  I asked for more
tests and am waiting for results.

Eh... I guess that's about it.  Enjoy your INBOX.  :-P

-- 
tejun
