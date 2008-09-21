Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbYIUU3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbYIUU3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbYIUU3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:29:33 -0400
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4757 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbYIUU3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:29:32 -0400
Date: Sun, 21 Sep 2008 22:29:15 +0200
From: Mark de Wever <koraq@xs4all.nl>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Gadi Oxman <gadio@netvision.net.il>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
Message-ID: <20080921202915.GA17945@localhost>
References: <20080921185138.GA16310@localhost> <48D69F5A.9010201@ru.mvista.com> <48D6A9BB.1070705@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D6A9BB.1070705@ru.mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 12:08:27AM +0400, Sergei Shtylyov wrote:
>>> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
>>> index 1bce84b..fd87b43 100644
>>> --- a/drivers/ide/ide-tape.c
>>> +++ b/drivers/ide/ide-tape.c
>>> @@ -2354,6 +2354,10 @@ static void  
>>> idetape_get_inquiry_results(ide_drive_t *drive)
>>>      ide_fixstring(product_id, 18, 0);
>>>      ide_fixstring(fw_rev, 6, 0);
>
>    Hm, I see that every string variable declared there has 2 extra  
> characters, and yet the author have managed to make a mistake... these 
> extra chars don't seem needed.

Those extra characters made me believe the intention was setting the
NULL character, therefore I used that solution in my patch.

Regards,
Mark de Wever
