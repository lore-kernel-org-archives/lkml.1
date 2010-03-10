Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0CJJUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:20:44 -0500
Received: from mail-iw0-f176.google.com ([209.85.223.176]:65297 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab0CJJUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:20:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=XhTWSuSmkHxKjyaBvz9f8wM/ZaGCyI+rzVshFJrx4dk+cdUTOYMIa88P4Y9cYqf+bn
         w0eoo+rRbaLsXKzh+kwNUplaTCBpu9EVRMQOXHxqIof65VPncy2kNccujvQcVBsgmSnc
         W1qADGSBRHmODrU179VJAYX/5fyiO/9cR0PuM=
MIME-Version: 1.0
In-Reply-To: <2ea1731b1003100002w104633ffy1ae46ef3d245e5b5@mail.gmail.com>
References: <4B968834.3040609@gmail.com>
	 <21eaeb5a1003091808s2d7638cxd524952a7d84b378@mail.gmail.com>
	 <2ea1731b1003100002w104633ffy1ae46ef3d245e5b5@mail.gmail.com>
Date: Wed, 10 Mar 2010 18:20:33 +0900
X-Google-Sender-Auth: 6fd769b5fa59e540
Message-ID: <21eaeb5a1003100120x6cd3f69ak598954af3c9fe955@mail.gmail.com>
Subject: Re: [PATCH v2] char drivers: Ram oops/panic logger
From: Yuasa Yoichi <yuasa@linux-mips.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/10 Marco Stornelli <marco.stornelli@gmail.com>:
> 2010/3/10 Yuasa Yoichi <yuasa@linux-mips.org>:
>> Hi,
>>
>> 2010/3/10 Marco Stornelli <marco.stornelli@gmail.com>:
>>> Ramoops, like mtdoops, can log oops/panic information but in RAM.
>>
>> What is different from mtdoops + mtd-ram?
>>
>> Yoichi
>>
>
> It can be used in a very easy way with persistent RAM for systems
> without flash support. For this systems, with this driver, it's no
> more needed add to the kernel the mtd subsystem with advantage in
> footprint as I said in the description.

right.
But,

> In addition, you can save
> flash space and store this information only in RAM. I think it's very
> useful for embedded systems.

CONFIG_MTD_RAM uses only RAM.
I think there's no big difference about this point.

Yoichi
