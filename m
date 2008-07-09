Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbYGILKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbYGILKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYGILKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:10:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:15036 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbYGILKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:10:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KYJ9FpHFzJ7EdMt0lIAXI8rP/CF7/xWCg3Q8Vg4Do/Tn4b7kQ38K+t83L2jR4Bu1cd
         FbDhr1HG/0QWDEfgA5SVxPg8o4s/qGnHeNglO2EyCPxdv32Uc/0FyXul9ogZpdlhRHKE
         j/HXk8pKsrdcxQaUftNOOraOxVUwkh3hlCucI=
Message-ID: <bc64b4640807090410h5448dfc0y6661daade8935107@mail.gmail.com>
Date: Wed, 9 Jul 2008 15:10:01 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: [patch 1/4] MFD: Use to_platform_device instead of container_of.
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       sameo@openedhand.com
In-Reply-To: <20080709104932.475821512@fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709104916.200210922@fluff.org>
	 <20080709104932.475821512@fluff.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/9 Ben Dooks <ben-linux@fluff.org>:
> Convert mfd_remove_devices_fn() to use to_platform_device()
> instead of doing container_of().
>
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Acked-by: Dmitry Baryshkov <dbaryshkov@gmail.com>

>
> Index: linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c
> ===================================================================
> --- linux-2.6.26-rc9-next20080709.orig/drivers/mfd/mfd-core.c   2008-07-09 10:13:53.000000000 +0100
> +++ linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c        2008-07-09 10:14:26.000000000 +0100
> @@ -99,8 +99,7 @@ EXPORT_SYMBOL(mfd_add_devices);
>
>  static int mfd_remove_devices_fn(struct device *dev, void *unused)
>  {
> -       platform_device_unregister(
> -                       container_of(dev, struct platform_device, dev));
> +       platform_device_unregister(to_platform_device(dev));
>        return 0;
>  }
>
>
> --
>



-- 
With best wishes
Dmitry
