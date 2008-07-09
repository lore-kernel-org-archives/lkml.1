Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbYGILLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbYGILLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757580AbYGILLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:11:24 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:46988 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229AbYGILLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:11:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gZ2G0UUMPsEsKXZ5Q7C7XZCOunN60oK4X5/gx1jjlLGbSDw2NezhaQZBa7z7AS3KTJ
         Kh6tCNGKDbVN7yHEyCfUTYlwtzUtRMQMgwJleJSSdJ0si1h4SWVhoReKHXTBsO0fieIl
         yXuqUCmYjpJ/+WqqPZvvJim+pq4sHb7qR9V8U=
Message-ID: <bc64b4640807090411y774949f4q3c0881e93afa50bf@mail.gmail.com>
Date: Wed, 9 Jul 2008 15:11:21 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: [patch 2/4] MFD: Coding style fixes
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       sameo@openedhand.com
In-Reply-To: <20080709104932.706237040@fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709104916.200210922@fluff.org>
	 <20080709104932.706237040@fluff.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/9 Ben Dooks <ben-linux@fluff.org>:
> Fix some coding style fixes in the mfd core driver.
>
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>

I don't have a strong feeling about this. As it's pretty much only
whitespace changes,
my feelings are closer to NAK.  Leaving decision to Samuel or Ian.

>
> Index: linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c
> ===================================================================
> --- linux-2.6.26-rc9-next20080709.orig/drivers/mfd/mfd-core.c   2008-07-09 10:43:54.000000000 +0100
> +++ linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c        2008-07-09 10:44:45.000000000 +0100
> @@ -16,9 +16,9 @@
>  #include <linux/mfd/core.h>
>
>  static int mfd_add_device(struct platform_device *parent,
> -               const struct mfd_cell *cell,
> -               struct resource *mem_base,
> -               int irq_base)
> +                         const struct mfd_cell *cell,
> +                         struct resource *mem_base,
> +                         int irq_base)
>  {
>        struct resource res[cell->num_resources];
>        struct platform_device *pdev;
> @@ -75,11 +75,10 @@ fail_alloc:
>        return ret;
>  }
>
> -int mfd_add_devices(
> -               struct platform_device *parent,
> -               const struct mfd_cell *cells, int n_devs,
> -               struct resource *mem_base,
> -               int irq_base)
> +int mfd_add_devices(struct platform_device *parent,
> +                   const struct mfd_cell *cells, int n_devs,
> +                   struct resource *mem_base,
> +                   int irq_base)
>  {
>        int i;
>        int ret = 0;
> Index: linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h
> ===================================================================
> --- linux-2.6.26-rc9-next20080709.orig/include/linux/mfd/core.h 2008-07-09 10:43:54.000000000 +0100
> +++ linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h      2008-07-09 10:44:45.000000000 +0100
> @@ -1,5 +1,3 @@
> -#ifndef MFD_CORE_H
> -#define MFD_CORE_H
>  /*
>  * drivers/mfd/mfd-core.h
>  *
> @@ -13,6 +11,9 @@
>  *
>  */
>
> +#ifndef MFD_CORE_H
> +#define MFD_CORE_H
> +
>  #include <linux/platform_device.h>
>
>  /*
> @@ -38,17 +39,15 @@ struct mfd_cell {
>        const struct resource   *resources;
>  };
>
> -static inline struct mfd_cell *
> -mfd_get_cell(struct platform_device *pdev)
> +static inline struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
>  {
>        return (struct mfd_cell *)pdev->dev.platform_data;
>  }
>
> -extern int mfd_add_devices(
> -               struct platform_device *parent,
> -               const struct mfd_cell *cells, int n_devs,
> -               struct resource *mem_base,
> -               int irq_base);
> +extern int mfd_add_devices(struct platform_device *parent,
> +                          const struct mfd_cell *cells, int n_devs,
> +                          struct resource *mem_base,
> +                          int irq_base);
>
>  extern void mfd_remove_devices(struct platform_device *parent);
>
>
> --
>



-- 
With best wishes
Dmitry
