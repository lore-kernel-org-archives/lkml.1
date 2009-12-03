Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZLCEuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZLCEuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 23:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZLCEuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 23:50:13 -0500
Received: from mail-pz0-f184.google.com ([209.85.222.184]:35413 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbZLCEuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 23:50:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=KLHT6fJfgFYNYg+h9RVE95EzDl4KDx5FZgkSxtsts9qOt787XsABg732aP2UX3QJii
         PZ6+KQoQMXVMZRGkBJet0x+bkPMsL85YOx2SKCOiIf/FCv4EfmjmgnY8Tr6qvgVvPAi0
         XouB/UNTjm0P+xOKHoV/dufQJnwHEWVCat2VA=
Subject: Re: [PATCH v0] Loongson2: CPUFreq: add support to load module
 automatically
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>, cpufreq@vger.kernel.org
In-Reply-To: <8421507f5dfc1a70d1dba92ad7604a8bfaa5a447.1259805106.git.wuzhangjin@gmail.com>
References: <8421507f5dfc1a70d1dba92ad7604a8bfaa5a447.1259805106.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Thu, 03 Dec 2009 12:49:55 +0800
Message-ID: <1259815795.4474.34.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> diff --git a/arch/mips/loongson/common/platform.c b/arch/mips/loongson/common/platform.c
> new file mode 100644
> index 0000000..fdb24fd
> --- /dev/null
> +++ b/arch/mips/loongson/common/platform.c
> @@ -0,0 +1,32 @@
> +/*
> + * Copyright (C) 2009 Lemote Inc.
> + * Author: Wu Zhangjin, wuzj@lemote.com
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +
> +#include <asm/bootinfo.h>

The above header file is not needed.

Regards,
	Wu Zhangjin

