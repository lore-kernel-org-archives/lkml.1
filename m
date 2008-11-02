Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbYKBUhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbYKBUhR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 15:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbYKBUhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 15:37:03 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:57458 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYKBUhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 15:37:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xszW6GxdUGFHHosexk55P5iEbrlX+wgsfma1XQhdssj6w+QzWGGjCoyxLD6G3NytsG
         8dLrSGXIsm+mSqmuFp2jmQ8CKoXjS+CF7zXby+6plIxnyLXoxplH/2RYMxjo6UhMyUvB
         DnneSP1ga/D2ZZa+pAj0CMy1d7722XoV9WuzQ=
Message-ID: <bc64b4640811021236k1518cf8awc36da8bcda259da@mail.gmail.com>
Date: Sun, 2 Nov 2008 23:36:58 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: change the way how wm97xx-bat driver is registered
Cc: cbou@mail.ru, "Andrew Morton" <akpm@linux-foundation.org>,
       "Dmitry Baryshkov" <dbaryshkov@gmail.com>,
       "Marek Vasut" <marek.vasut@gmail.com>
In-Reply-To: <1225271050-21171-2-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com>
	 <1225271050-21171-2-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/29 Dmitry Baryshkov <dbaryshkov@gmail.com>:
> Do register the driver from wm97xx_bat_set_pdata instead of module init.
> This has several positive outcome points:
> 1) This driver for wm97xx-battery is now registered on demand, thus allowing
>  other driver (e.g. tosa-battery) to claim the battery.
> 2) After dropping __init from wm97xx_bat_set_pdata(), the wm97xx_bat driver
>  can be correctly built as a module. Then one can request it and set the
>  battery data.
>
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Cc: Marek Vasut <marek.vasut@gmail.com>
> ---
>  drivers/power/Kconfig          |    4 ++--
>  drivers/power/wm97xx_battery.c |   12 +++++-------
>  include/linux/wm97xx_batt.h    |    7 +++++--
>  3 files changed, 12 insertions(+), 11 deletions(-)

What about this patch?


-- 
With best wishes
Dmitry
