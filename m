Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZGHPcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZGHPcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 11:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbZGHPcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 11:32:43 -0400
Received: from smtp.nokia.com ([192.100.105.134]:37653 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbZGHPcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 11:32:42 -0400
Message-ID: <4A54BBFC.8010404@gmail.com>
Date: Wed, 08 Jul 2009 18:32:12 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] VFS: introduce helpers for manipulation s_dirty flag
References: <20090707180541.17048.49901.sendpatchset@localhost.localdomain> <20090707180548.17048.74367.sendpatchset@localhost.localdomain> <4A547050.20606@panasas.com>
In-Reply-To: <4A547050.20606@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Jul 2009 15:32:18.0268 (UTC) FILETIME=[471E91C0:01C9FFE1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
>> @@ -271,7 +271,7 @@ static void exofs_put_super(struct super_block *sb)
>>  
>>  	lock_kernel();
>>  
>> -	if (sb->s_dirt)
>> +	if (is_sb_dirty(sb))
>>  		exofs_write_super(sb);
>>  
>>  	/* make sure there are no pending commands */
> <snip>
> 
> I have just asked a pull request from Linus with a patch that adds
> one more "if (sb->s_dirt)" call site. So if he pulls it into 2.6.31-rc3
> I'll send you a mail and you can update. If not then it will go in at
> 2.6.32, please tel me when this is going into linux-next and through which
> tree, and I'll sync with it.

[Sorry for wrong e-mail address]

Sure, thanks, I'll keep this in mind.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
