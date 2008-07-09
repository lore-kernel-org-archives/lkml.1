Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbYGILJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbYGILJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYGILJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:09:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:14801 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYGILJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:09:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xMh/7lXF3MTCv7EPZaiSKngXwzDTSdrAdM0NkRpsELY+iX7Px4p7aC0qssnKLeFMi4
         QvTiSM/FBR1cVfQ6tcc2N8rUCPZoSw70UWQ+3rBBZFeXUaYIo8vvknHtcYM//4pbIHCI
         EYaQ8F/meXzeeGR9+7CtNXeYvFwAk0fIWjR4I=
Message-ID: <bc64b4640807090409h2ebb8f4embae20b8511fbe459@mail.gmail.com>
Date: Wed, 9 Jul 2008 15:09:12 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: [patch 3/4] MFD: Remove unnecessary fields if mfd_cell structure.
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       sameo@openedhand.com
In-Reply-To: <20080709104932.905074060@fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709104916.200210922@fluff.org>
	 <20080709104932.905074060@fluff.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/9 Ben Dooks <ben-linux@fluff.org>:
> The enable,disable,suspend and resume entry in the struct mfd_cell
> do not seem to be necessary as they should be handled by the
> platform driver that the device created has bound to.

NAK. It's used e.g. by the tmio-nand driver. These fields provide easy
way to support
enhanced power management, etc.

>
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
>
> Index: linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h
> ===================================================================
> --- linux-2.6.26-rc9-next20080709.orig/include/linux/mfd/core.h 2008-07-09 10:44:45.000000000 +0100
> +++ linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h      2008-07-09 10:45:06.000000000 +0100
> @@ -23,12 +26,6 @@
>  */
>  struct mfd_cell {
>        const char              *name;
> -
> -       int                     (*enable)(struct platform_device *dev);
> -       int                     (*disable)(struct platform_device *dev);
> -       int                     (*suspend)(struct platform_device *dev);
> -       int                     (*resume)(struct platform_device *dev);
> -
>        void                    *driver_data; /* driver-specific data */
>
>        /*
>
> --
>



-- 
With best wishes
Dmitry
