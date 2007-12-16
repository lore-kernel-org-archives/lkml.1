Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbXLPTm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbXLPTm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 14:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbXLPTmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 14:42:17 -0500
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:54600 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751615AbXLPTmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 14:42:17 -0500
Date: Sun, 16 Dec 2007 20:42:14 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "eric miao" <eric.y.miao@gmail.com>
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org,
       "David Brownell" <david-b@pacbell.net>,
       "Ben Gardner" <bgardner@wabtec.com>
Subject: Re: [PATCH 2.6.24-rc5-mm 3/3] gpiolib: obsolete
 drivers/i2c/chips/pca9539.c
Message-ID: <20071216204214.01fd7a16@hyperion.delvare>
In-Reply-To: <f17812d70712142016q73abffc2w99174c40f847152c@mail.gmail.com>
References: <f17812d70712142016q73abffc2w99174c40f847152c@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

On Sat, 15 Dec 2007 12:16:50 +0800, eric miao wrote:
> From 0bca662f68e7ffe84f333d7d26df25d846713db2 Mon Sep 17 00:00:00 2001
> From: eric miao <eric.miao@marvell.com>
> Date: Sat, 15 Dec 2007 12:07:26 +0800
> Subject: [PATCH] gpiolib: obsolete drivers/i2c/chips/pca9539.c
> 
> for the following reasons:
> 
> 1. there is currently no known users of this driver
> 
> 2. the functionality of this driver is well supported with the recent
>    proposed drivers/gpio/pca9539.c, using GPIO_LIB
> 

This is fine with me, however...

> Signed-off-by: eric miao <eric.miao@marvell.com>
> Acked-by: Ben Gardner <bgardner@wabtec.com>
> ---
>  drivers/i2c/chips/Kconfig   |   10 --
>  drivers/i2c/chips/Makefile  |    1 -
>  drivers/i2c/chips/pca9539.c |  196 -------------------------------------------

... please also delete Documentation/i2c/chips/pca9539.

>  3 files changed, 0 insertions(+), 207 deletions(-)
>  delete mode 100644 drivers/i2c/chips/pca9539.c

-- 
Jean Delvare
