Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZBQAun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZBQAun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 19:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZBQAue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 19:50:34 -0500
Received: from h155.mvista.com ([63.81.120.155]:4375 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751170AbZBQAud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 19:50:33 -0500
Message-ID: <499A09D3.8070303@ru.mvista.com>
Date: Tue, 17 Feb 2009 03:50:27 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] ide: use ->tf_read in ide_read_error()
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <49995856.0@ru.mvista.com> <49995B44.6090604@ru.mvista.com> <200902162217.08541.bzolnier@gmail.com> <499A0181.8000008@ru.mvista.com>
In-Reply-To: <499A0181.8000008@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>>       
>>>    I meant IDE_TFLAG_IN_HOB_FEATURE, of course.
>>>     
>>
>> Once again blame the certain ioctl (you know which one)... :)
>>   
>   Moreover, the error register shoudn't be affeceted by the HOB bit, 
> so this flag doesn't make sense.
>
>   Oh, horror... and I know that it wasn't completely ungrounded since 
> both ATA/PI-6 adn -7 have words about reading the features register 
> (depending on HOB). At least ATA/PI-8 got rid of this. Anyway, I think 
> we can safely get rid of this flag and just return the same value in 
> 'features' and 'hob_features'.

  Although, after thinking a bit more, it doesn't seem worth the trouble 
-- so the rename should suffice...

MBR, Sergei


