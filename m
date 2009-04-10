Return-Path: <linux-kernel-owner+w=401wt.eu-S936422AbZDJRtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936422AbZDJRtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764908AbZDJRtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:49:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:32266 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbZDJRtD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:49:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tTfozlgXeTGgN9iM62RpLqiOPCKdhy+IYm+SQXtwipq0P9OyLG7AmY1frQBh1mgVSm
         82Mtsv1IGNSAvHijMlGRvSLRNjQKP0oZOnMc3ZsR6tI4jGLlyzI1gZlkIxGgvy+mmX7q
         rC28bSPpMi3jvkZe5+ROGlJMt1MT/l/6xW7jk=
MIME-Version: 1.0
In-Reply-To: <69e28c910904100953uc0c0811i6ea8dee19a956951@mail.gmail.com>
References: <15d0b9b20904100916u3ff85ff5gd7a989120b7c048f@mail.gmail.com>
	 <69e28c910904100953uc0c0811i6ea8dee19a956951@mail.gmail.com>
Date: Fri, 10 Apr 2009 19:49:01 +0200
Message-ID: <15d0b9b20904101049h1020f9d7yec3242e3c7cbc06b@mail.gmail.com>
Subject: Re: Additional USB identifier for otus driver [WN111v2]
From: Daniele Napolitano <dnax88@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       akpm@linux-foundation.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/10 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Fri, Apr 10, 2009 at 6:16 PM, Daniele Napolitano <dnax88@gmail.com> wrote:
>> This is a patch for Otus driver [Atheros 9k series] that provide
>> support for WN111v2 USB 802.11n
>> adapter.
>>
>> Otus sources tree: OAL/Otus/Linux
>>
>> --- zdusb.h.orig        2009-04-10 17:48:17.620423000 +0200
>> +++ zdusb.h     2009-04-10 17:54:41.356419568 +0200
>> @@ -26,5 +26,9 @@
>>
>>
>>  #define VENDOR_DLINK            0x07D1  //Dlink
>>
>>  #define PRODUCT_DWA160A         0x3C10
>>
>> +
>> +#define VENDOR_NETGEAR          0x0846  //NetGear
>> +#define PRODUCT_WNDA3100        0x9010
>> +#define PRODUCT_WN111v2         0x9001
>>
>>
>>  #endif
>>
>>
>> --- zdusb.c.orig        2009-04-10 17:48:17.620423000 +0200
>> +++ zdusb.c     2009-04-10 17:53:15.316421516 +0200
>> @@ -36,7 +36,8 @@
>>  static struct usb_device_id zd1221_ids [] = {
>>
>>        { USB_DEVICE(VENDOR_ATHR, PRODUCT_AR9170) },
>>
>>         { USB_DEVICE(VENDOR_DLINK, PRODUCT_DWA160A) },
>>
>> -       { USB_DEVICE(0x0846, 0x9010) },
>>
>> +       { USB_DEVICE(VENDOR_NETGEAR, PRODUCT_WNDA3100) },
>> +       { USB_DEVICE(VENDOR_NETGEAR, PRODUCT_WN111v2) },
>>
>>        { }                                     /* Terminating entry */
>>
>>  };
>>
>>
>>
>>
>> --
>> Daniele "DnaX" Napolitano
>> https://launchpad.net/~dnax88
>> http://dnax.netsons.org/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Need the same for ar9170.

Already present. Look at main.c at line 52 of ar9170 tree.

-- 
Daniele "DnaX" Napolitano
https://launchpad.net/~dnax88
http://dnax.netsons.org/
