Return-Path: <linux-kernel-owner+w=401wt.eu-S1762218AbZDHOQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762218AbZDHOQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933390AbZDHOMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:12:22 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53820 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933484AbZDHOMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:12:21 -0400
X-Sasl-enc: C8639edck4pxTog7vD92I7+EkT+/IBElk0JWyHf1aGpP 1239199938
Message-ID: <49DCB0BA.70606@fastmail.fm>
Date: Wed, 08 Apr 2009 15:12:10 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Will Newton <will.newton@gmail.com>
CC: Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 20/56] inflate: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>	 <36ca99e90904080439u7098d2feka5dd39f8ab6a470c@mail.gmail.com>	 <49DCAC88.7010500@fastmail.fm> <87a5b0800904080705n74829b75l8becfd6e7d1a321f@mail.gmail.com>
In-Reply-To: <87a5b0800904080705n74829b75l8becfd6e7d1a321f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Newton wrote:
> On Wed, Apr 8, 2009 at 2:54 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
>   
>>  lib/inflate.c |    5 ++---
>>  1 files changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/lib/inflate.c b/lib/inflate.c
>> index 1a8e8a9..1eb0cd8 100644
>> --- a/lib/inflate.c
>> +++ b/lib/inflate.c
>> @@ -249,7 +249,7 @@ static void *malloc(int size)
>>
>>        malloc_ptr = (malloc_ptr + 3) & ~3;     /* Align */
>>
>> -       p = (void *)malloc_ptr;
>> +       p = malloc_ptr;
>>        malloc_ptr += size;
>>     
>
> Won't this cause a "assignment makes pointer from integer without a
> cast" warning?
I don't think so. The cast had no effect as both malloc_ptr and p are
declared as void *. The later += size
does pointer arithmetic.

Thanks,

Jack
