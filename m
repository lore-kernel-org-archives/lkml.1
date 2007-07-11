Return-Path: <linux-kernel-owner+w=401wt.eu-S1764222AbXGKQDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764222AbXGKQDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbXGKQDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:03:33 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:51559 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754778AbXGKQDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:03:32 -0400
Date: Wed, 11 Jul 2007 18:03:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled i2c-rpx removal
Message-ID: <20070711180348.02dfd257@hyperion.delvare>
In-Reply-To: <20070709145724.GC3492@stusta.de>
References: <20070709145724.GC3492@stusta.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Mon, 9 Jul 2007 16:57:24 +0200, Adrian Bunk wrote:
> This patch contains the scheduled removal of the i2c-rpx driver.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
>  Documentation/feature-removal-schedule.txt |    8 -
>  Documentation/i2c/summary                  |    1 
>  drivers/i2c/algos/Kconfig                  |    4 
>  drivers/i2c/busses/Kconfig                 |    5 -
>  drivers/i2c/busses/Makefile                |    1 
>  drivers/i2c/busses/i2c-rpx.c               |  101 ---------------------
>  6 files changed, 120 deletions(-)

I already have a patch doing this in my tree.

Also note that the entry in feature-removal-schedule.txt never made it
to mainline (it was in -mm only), so it can't be removed.

In theory there is a driver rewrite in progress, so my plan is to
include this removal patch into -mm for now, and send it to Linus only
for 2.6.24 if I don't receive an acceptable driver meanwhile.

Thanks,
-- 
Jean Delvare
