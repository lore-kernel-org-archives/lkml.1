Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab0CARRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:17:51 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:60403 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab0CARRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:17:50 -0500
Message-ID: <4B8BF641.1050109@oracle.com>
Date: Mon, 01 Mar 2010 09:15:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: Dave Airlie <airlied@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH] drm: fix char constant (sparse warning)
References: <20100224142759.ad4f53ce.randy.dunlap@oracle.com>	 <21d7e9971002282201p3f932729nc00a60bc5eadd492@mail.gmail.com> <a728f9f91003010906x6103bee9pe72a28f63f04b984@mail.gmail.com>
In-Reply-To: <a728f9f91003010906x6103bee9pe72a28f63f04b984@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B8BF6AA.000B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/10 09:06, Alex Deucher wrote:
> On Mon, Mar 1, 2010 at 1:01 AM, Dave Airlie <airlied@gmail.com> wrote:
>> On Thu, Feb 25, 2010 at 8:27 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> Fix radeon/atombios.h sparse warning (24 times):
>>>
>>> drivers/gpu/drm/radeon/atombios.h:4091:63: error: Bad character constant
>>
>> We get this file from AMD pretty much as-is and I hate deviating it as it
>> causes merge issues. Alex any change you can get this fixed upstream?

Ah, thanks for that info.

>>
> 
> I can try.
> 
> Alex

OK, thanks.

>> Dave.
>>
>>>
>>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>>> Cc:     David Airlie <airlied@linux.ie>
>>> ---
>>>  drivers/gpu/drm/radeon/atombios.h |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> --- linux-2.6.33-rc8.orig/drivers/gpu/drm/radeon/atombios.h
>>> +++ linux-2.6.33-rc8/drivers/gpu/drm/radeon/atombios.h
>>> @@ -4088,7 +4088,7 @@ typedef struct _SW_I2C_IO_DATA_PARAMETER
>>>  #define SW_I2C_CNTL_WRITE1BIT 6
>>>
>>>  /* ==============================VESA definition Portion=============================== */
>>> -#define VESA_OEM_PRODUCT_REV                               '01.00'
>>> +#define VESA_OEM_PRODUCT_REV                               "01.00"
>>>  #define VESA_MODE_ATTRIBUTE_MODE_SUPPORT            0xBB       /* refer to VBE spec p.32, no TTY support */
>>>  #define VESA_MODE_WIN_ATTRIBUTE                                                     7
>>>  #define VESA_WIN_SIZE                                                                                       64
>>> --


-- 
~Randy
