Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab0CJMPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 07:15:31 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51989 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0CJMP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 07:15:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lovU7QDj3F82KH7RExZZC4NO2MxOicu5Kf5ROsLVzRuQe2iKW6Wv3gDQCCIgR8x9+y
         91ZFpss2tTGF7tOq+PMyM9KRPcts2kzYEBLFjGUpyRM/uq61Oa9d+ipbPZupJTdBCU8/
         oBTNIkLSTqmEfp/mJ3Mq06T2D8EMkGH36zdNM=
MIME-Version: 1.0
In-Reply-To: <21eaeb5a1003100120x6cd3f69ak598954af3c9fe955@mail.gmail.com>
References: <4B968834.3040609@gmail.com>
	 <21eaeb5a1003091808s2d7638cxd524952a7d84b378@mail.gmail.com>
	 <2ea1731b1003100002w104633ffy1ae46ef3d245e5b5@mail.gmail.com>
	 <21eaeb5a1003100120x6cd3f69ak598954af3c9fe955@mail.gmail.com>
Date: Wed, 10 Mar 2010 13:15:25 +0100
Message-ID: <2ea1731b1003100415i46dd8fcem85b85f49fb1a479@mail.gmail.com>
Subject: Re: [PATCH v2] char drivers: Ram oops/panic logger
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Yuasa Yoichi <yuasa@linux-mips.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/10 Yuasa Yoichi <yuasa@linux-mips.org>:
> 2010/3/10 Marco Stornelli <marco.stornelli@gmail.com>:
>> 2010/3/10 Yuasa Yoichi <yuasa@linux-mips.org>:
>>> Hi,
>>>
>>> 2010/3/10 Marco Stornelli <marco.stornelli@gmail.com>:
>>>> Ramoops, like mtdoops, can log oops/panic information but in RAM.
>>>
>>> What is different from mtdoops + mtd-ram?
>>>
>>> Yoichi
>>>
>>
>> It can be used in a very easy way with persistent RAM for systems
>> without flash support. For this systems, with this driver, it's no
>> more needed add to the kernel the mtd subsystem with advantage in
>> footprint as I said in the description.
>
> right.
> But,
>
>> In addition, you can save
>> flash space and store this information only in RAM. I think it's very
>> useful for embedded systems.
>
> CONFIG_MTD_RAM uses only RAM.
> I think there's no big difference about this point.
>

I meant with the "classic" use of mtdoops, therefore with a flash
partition without use MTD_RAM. Using MTD_RAM, it's more or less the
same thing, with the exception of "where" you want deploy the log. For
example: if in your system you have got a nvram you can use it without
problem, you need to specify the address of the nvram to the module.
Very simple. I  think it's a small driver but very useful, feedback
from other embedded guys are welcome.

Marco
