Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbZETIg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbZETIg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZETIgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:36:23 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:63749 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbZETIgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qcVNV4+aNtSetnSL8owKmBb/tgbfol31sVne9pBEU+YFUJEgjqpJPecuwiqCpf+LTT
         2NRaHGxGvxV1yuIYUpS69K5OEkZ934Z4Kyb3wXCJdTzourEIPh9bxQzWTW1gvfY0/RAl
         GBulmtGJrL9RDIN7lcykskLL4HzJ+7qqla+Fo=
MIME-Version: 1.0
In-Reply-To: <20090519230601.GF23114@fluff.org.uk>
References: <63386a3d0905190736q574d0379hb529aaa105aa36f3@mail.gmail.com>
	 <20090519230601.GF23114@fluff.org.uk>
Date: Wed, 20 May 2009 10:36:22 +0200
Message-ID: <63386a3d0905200136i64bde4acw8944443a005f5d30@mail.gmail.com>
Subject: Re: [PATCH 1/1] MFD: Add U300 AB3100 core support v3
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
       linux-i2c@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Ben, v4 due soon..

2009/5/20 Ben Dooks <ben-linux@fluff.org>:

>> +#define AB3100_DEVICE(devname, devid, regstart, regend)              \
>> +static struct resource ab3100_##devname##_resource[] = {     \
>> +     {                                                       \
>> +             .start  = regstart,                             \
>> +             .end    = regend,                               \
>> +             .flags  = IORESOURCE_IO,                        \
>> +     }                                                       \
>
> is IORESOURCE_IO a good idea here, we may need to add some form of
> flag to say 'generic data' and for the driver core to not try and
> register it with any of the ioport or iomem structures.

I'll remove it for the time being, it's not used currently anyway.

Yell if you want me to create a patch to include/linux/platform_devices.h
for this too...

>> +     {
>> +             .id = 0xc8,
>> +             .name = "P2B/R2B"
>> +     },
>
> doing }, { would makes these shorter still.

Yeah CodingStyle actually say so if I read it closely, I'll fix.

Yours,
Linus Walleij
