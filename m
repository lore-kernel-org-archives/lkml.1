Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbXEBHpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbXEBHpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964796AbXEBHpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:45:06 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1259 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbXEBHpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:45:02 -0400
X-Greylist: delayed 740 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2007 03:45:02 EDT
Message-ID: <24627.194.196.35.3.1178091127.squirrel@webmail.xs4all.nl>
In-Reply-To: <1178039010.6754.20.camel@localhost>
References: <Pine.LNX.4.64.0704280628180.571@localhost.localdomain>
    <1178039010.6754.20.camel@localhost>
Date: Wed, 2 May 2007 09:32:07 +0200 (CEST)
Subject: Re: [v4l-dvb-maintainer] Re: [PATCH] VIDEO4LINUX-2: Replace 
     MINOR() with a call to iminor().
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Andrew Morton" <akpm@osdl.org>, "Hans Verkuil" <hverkuil@xs4all.nl>,
       michael@mihu.de,
       "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Robert,
>
> Em Sáb, 2007-04-28 às 06:32 -0400, Robert P. J. Day escreveu:
>> Replace the call to MINOR() with a call to the inline iminor()
>> routine.
>>
>> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
>>
>> ---
>>
>> that's the last of those changes, but it's not clear who the official
>> maintainer is, so i took a chance and picked a likely looking victim
>> out of the MAINTAINERS file.  apologies if i picked wrong.
>
> You've picked it wrongly. The Maintainer for ivtv is Hans Verkuil.
> However, for every stuff under drivers/media, you can reach the active
> maintainers at v4l-dvb-maintainers list
> (v4l-dvb-maintainer@linuxtv.org).
>
> Hans,
>
> If you are ok with this trivial change, please send me your acked-by or
> SOB for me to commit and send to mainstream.

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

       Hans

>>
>>
>> diff --git a/drivers/media/video/ivtv/ivtv-fileops.c
>> b/drivers/media/video/ivtv/ivtv-fileops.c
>> index 1637097..8976487 100644
>> --- a/drivers/media/video/ivtv/ivtv-fileops.c
>> +++ b/drivers/media/video/ivtv/ivtv-fileops.c
>> @@ -804,7 +804,7 @@ int ivtv_v4l2_open(struct inode *inode, struct file
>> *filp)
>>  	struct ivtv_open_id *item;
>>  	struct ivtv *itv = NULL;
>>  	struct ivtv_stream *s = NULL;
>> -	int minor = MINOR(inode->i_rdev);
>> +	int minor = iminor(inode);
>>
>>  	/* Find which card this open was on */
>>  	spin_lock(&ivtv_cards_lock);
> --
> Cheers,
> Mauro
>
>
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer
>


