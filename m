Return-Path: <linux-kernel-owner+w=401wt.eu-S933985AbZDHOT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985AbZDHOT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933948AbZDHOSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:18:25 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54838 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZDHOSY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jfmvnf4jvToHy1jCZEK8MxsLaO8efq59d0vPuleTfj6LN1gah55U4xKKLMFEdqKaGQ
         iIk938Q/Gakuo+OFh54oBKRCrIevQGxZ8NnOAiS5a9CJAjghiLpbxnvcTE3kgUju1rDV
         ah3KuNhyKau9jRUFXPOH2ABs0kZkO87nCTPGc=
MIME-Version: 1.0
In-Reply-To: <49DCB0BA.70606@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
	 <36ca99e90904080439u7098d2feka5dd39f8ab6a470c@mail.gmail.com>
	 <49DCAC88.7010500@fastmail.fm>
	 <87a5b0800904080705n74829b75l8becfd6e7d1a321f@mail.gmail.com>
	 <49DCB0BA.70606@fastmail.fm>
Date: Wed, 8 Apr 2009 15:18:22 +0100
Message-ID: <87a5b0800904080718y424776b2u6f505192408dbbbd@mail.gmail.com>
Subject: Re: [PATCH 20/56] inflate: Remove void casts
From: Will Newton <will.newton@gmail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 3:12 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
> Will Newton wrote:
>> On Wed, Apr 8, 2009 at 2:54 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
>>
>>>  lib/inflate.c |    5 ++---
>>>  1 files changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/lib/inflate.c b/lib/inflate.c
>>> index 1a8e8a9..1eb0cd8 100644
>>> --- a/lib/inflate.c
>>> +++ b/lib/inflate.c
>>> @@ -249,7 +249,7 @@ static void *malloc(int size)
>>>
>>>        malloc_ptr = (malloc_ptr + 3) & ~3;     /* Align */
>>
>>> -       p = (void *)malloc_ptr;
>>> +       p = malloc_ptr;
>>>        malloc_ptr += size;
>>>
>>
>> Won't this cause a "assignment makes pointer from integer without a
>> cast" warning?
> I don't think so. The cast had no effect as both malloc_ptr and p are
> declared as void *. The later += size
> does pointer arithmetic.

static unsigned long malloc_ptr;

Please compile test your code.

> Thanks,
>
> Jack
>
