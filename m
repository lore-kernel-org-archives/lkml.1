Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbYBETAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbYBETAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbYBES77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:59:59 -0500
Received: from ag-out-0708.google.com ([72.14.246.240]:4857 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759356AbYBES75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:59:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ABDp1S7ntTS/6b8t02TOXSQ2sIp2qUz4qDIIu4YktLTs22N/v0hZZykKRTC5g0ImRtMoba/NeqVpDAkUg5Tz+x8ykufzRlaZcVHYbDy2CPie7npP+Mc1V1DWF8xAt+jYoLuqnYsT+1Dr/MS+m8ckQFFxFqDVJeB+aFUH0fOP7ZE=
Message-ID: <8bd0f97a0802051059kb108412x7285ebbf82342d48@mail.gmail.com>
Date: Tue, 5 Feb 2008 13:59:52 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] [Blackfin] char driver for Blackfin on-chip OTP memory
Cc: "Bryan Wu" <bryan.wu@analog.com>, linux-kernel@vger.kernel.org,
       "Mike Frysinger" <michael.frysinger@analog.com>
In-Reply-To: <47A058B3.6000009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201689401-2892-1-git-send-email-bryan.wu@analog.com>
	 <47A058B3.6000009@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 6:00 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 01/30/2008 11:36 AM, Bryan Wu wrote:
> > +
> > +     ret = cdev_add(&bfin_otp_cdev, bfin_otp_dev_node, 1);
> > +     if (ret) {
> > +             unregister_chrdev_region(bfin_otp_dev_node, 1);
> > +             printk(KERN_ERR PFX "unable to register char device\n");
> > +             return ret;
> > +     }
> > +
> > +     bfin_otp_class = class_create(THIS_MODULE, "otp");
> > +     device_create(bfin_otp_class, NULL, bfin_otp_dev_node, "otp");
>
> Anyway, wouldn't be easier/better to use misc.c functionality here
> (misc_register() et al.)?

thanks, ive converted this now ... Bryan can post an updated patch :)
http://blackfin.uclinux.org/gf/project/linux-kernel/scmsvn/?action=browse&path=/trunk/drivers/char/bfin-otp.c&r1=4224&r2=4223
-mike
