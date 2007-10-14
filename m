Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbXJNLST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbXJNLST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 07:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbXJNLSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 07:18:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:46774 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbXJNLSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 07:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=ffZ2QiTQAgUehuV8Fgs+xnpO8/GiHCZu3rMnNHDEE0uc0Rq8WJuLhwfNQ7fcuUPq6rgEkIPy2pIIJDluK69UafYaV9jHEoPznyTK7QcxJNAzfuzBs86dXDeDCb/LPGkxvJjPvzVe0U39R4YDLjsCKInschryD7gLZByPcgMi2u0=
Date: Sun, 14 Oct 2007 13:18:01 +0200
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-git2 buid failure
Message-ID: <20071014111801.GB12462@Ahmed>
References: <471070A3.6020003@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <471070A3.6020003@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 12:45:47PM +0530, Kamalesh Babulal wrote:
> Hi,
> 
> The 2.6.23-git2 build fails with build error 
> 
>   CC [M]  drivers/mmc/core/core.o
>   CC [M]  drivers/mmc/core/sysfs.o
>   CC [M]  drivers/mmc/core/bus.o
>   CC [M]  drivers/mmc/core/host.o
> drivers/mmc/core/host.c: In function â€˜mmc_remove_hostâ€™:
> drivers/mmc/core/host.c:146: error: implicit declaration of function â€˜led_trigger_unregisterâ€™
> drivers/mmc/core/host.c:146: error: â€˜struct mmc_hostâ€™ has no member named â€˜ledâ€™
> make[3]: *** [drivers/mmc/core/host.o] Error 1
> make[2]: *** [drivers/mmc/core] Error 2
> make[1]: *** [drivers/mmc] Error 2
> make: *** [drivers] Error 2
> 

You can fix it using this patch: http://lkml.org/lkml/2007/10/12/380
Or the patch titled: mmc-fix-compile-without-led-triggers.patch

Regards,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
