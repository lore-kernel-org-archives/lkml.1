Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYIRIlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYIRIlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 04:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYIRIlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 04:41:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:47774 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbYIRIlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 04:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Llp1qvt3NByBIJlBjzPMwWUdLvvZuSJxMJzA2DKUxDsFklmyeBulclAWq7ocNrMw2F
         I6au0M+L37EoL7LAkI1IB8iH6wTtOE6fKG7VUdvDWhB5C+a8X5WPWaDDeO/49xDfbOlJ
         fvOxy8IikgWExEXrpUbTpzfP0RGFKjAEt12bk=
Message-ID: <48D21424.9030807@gmail.com>
Date: Thu, 18 Sep 2008 10:41:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, Anssi Hannula <anssi.hannula@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] HID: move pantherlord FF processing
References: <1220533187-21848-1-git-send-email-jirislaby@gmail.com> <alpine.LNX.1.10.0809171900030.19221@pegasus.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0809171900030.19221@pegasus.suse.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2008 07:03 PM, Jiri Kosina wrote:
> On Thu, 4 Sep 2008, Jiri Slaby wrote:
> 
>> Move the force feedback precessing into a separate module.
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
>> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
>> index 0784a09..a4d9695 100644
>> --- a/drivers/hid/hid-ids.h
>> +++ b/drivers/hid/hid-ids.h
>> @@ -373,6 +373,8 @@
>>  #define USB_DEVICE_ID_QUAD_USB_JOYPAD	0x8800
>>  #define USB_DEVICE_ID_DUAL_USB_JOYPAD	0x8866
>>  
>> +#define USB_VENDOR_ID_GREENASIA		0x0e8f
>> +
>>  #define USB_VENDOR_ID_WISEGROUP_LTD	0x6666
>>  #define USB_VENDOR_ID_WISEGROUP_LTD2	0x6677
>>  #define USB_DEVICE_ID_SMARTJOY_DUAL_PLUS 0x8802
> 
> Could we please preserve alphabetical ordering in hid-ids.h file?

Oops, sorry for that, I tried to sort it numerically not noticing it's sorted
alphabetically.

> Otherwise the series looks good to me, and Anssi didn't complain as well. 
> Could you please rebase it on top of the current HID tree, fix the 
> ordering, and send it to me again, I will apply it?

No problem.

Thanks.
