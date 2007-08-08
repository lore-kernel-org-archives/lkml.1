Return-Path: <linux-kernel-owner+w=401wt.eu-S937903AbXHHVbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937903AbXHHVbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764774AbXHHVbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:31:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59934 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755713AbXHHVba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:31:30 -0400
Date: Wed, 8 Aug 2007 23:31:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc1-mm2: MMC_ARMMMCI compile error
Message-ID: <20070808213114.GK6997@stusta.de>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 11:09:32PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc1-mm1:
>...
>  git-mmc.patch
>...
>  git trees
>...

CONFIG_MMC_ARMMMCI=m/y results in the following compile error:

<--  snip  -->

...
  CC [M]  drivers/mmc/host/mmci.o
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc1-mm2/drivers/mmc/host/mmci.c: In function 'mmci_request':
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc1-mm2/drivers/mmc/host/mmci.c:398: error: implicit declaration of function 'mmc_end_request'
make[4]: *** [drivers/mmc/host/mmci.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

