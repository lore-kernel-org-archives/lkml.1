Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab0CARGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:06:36 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:63336 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab0CARGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:06:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NmhkowLpbQ5WYe4sb9+ihPjX7RkgUI8PvrSR/GLAB5V7lHYSsThQiSgcguJvubsR1p
         CCKCKX0dk4itzUgz2tk2YiQFPQGH4I+VopBv14gD2l7dyvt6tNI2yFqgnNBZ42DevKfj
         cCL82Bi9ao8zaR4oPquKYkPrvYMWMe85j5I/I=
MIME-Version: 1.0
In-Reply-To: <21d7e9971002282201p3f932729nc00a60bc5eadd492@mail.gmail.com>
References: <20100224142759.ad4f53ce.randy.dunlap@oracle.com>
	 <21d7e9971002282201p3f932729nc00a60bc5eadd492@mail.gmail.com>
Date: Mon, 1 Mar 2010 12:06:31 -0500
Message-ID: <a728f9f91003010906x6103bee9pe72a28f63f04b984@mail.gmail.com>
Subject: Re: [PATCH] drm: fix char constant (sparse warning)
From: Alex Deucher <alexdeucher@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 1:01 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Thu, Feb 25, 2010 at 8:27 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix radeon/atombios.h sparse warning (24 times):
>>
>> drivers/gpu/drm/radeon/atombios.h:4091:63: error: Bad character constant
>
> We get this file from AMD pretty much as-is and I hate deviating it as it
> causes merge issues. Alex any change you can get this fixed upstream?
>

I can try.

Alex

> Dave.
>
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc:     David Airlie <airlied@linux.ie>
>> ---
>>  drivers/gpu/drm/radeon/atombios.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- linux-2.6.33-rc8.orig/drivers/gpu/drm/radeon/atombios.h
>> +++ linux-2.6.33-rc8/drivers/gpu/drm/radeon/atombios.h
>> @@ -4088,7 +4088,7 @@ typedef struct _SW_I2C_IO_DATA_PARAMETER
>>  #define SW_I2C_CNTL_WRITE1BIT 6
>>
>>  /* ==============================VESA definition Portion=============================== */
>> -#define VESA_OEM_PRODUCT_REV                               '01.00'
>> +#define VESA_OEM_PRODUCT_REV                               "01.00"
>>  #define VESA_MODE_ATTRIBUTE_MODE_SUPPORT            0xBB       /* refer to VBE spec p.32, no TTY support */
>>  #define VESA_MODE_WIN_ATTRIBUTE                                                     7
>>  #define VESA_WIN_SIZE                                                                                       64
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
