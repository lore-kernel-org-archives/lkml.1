Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbYA3NPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbYA3NPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760339AbYA3NP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:15:26 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:5634 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758389AbYA3NPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:15:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pq6Urpa5+2cYrPIASMzrlyN3gF793SiV61mU1sgZui+egVrLFFHbJd7+B4X0Ep1DSTQSSE3UeASwRSwbkLow6hVK6z4xPVPOy5WQT+MvR1scfSpJVCDpYxCaOEs2UvdsoZgnPyM8PUu8zq1ZYuthhjPlPWnLYiHYYk5WtuVPvZg=
Message-ID: <386072610801300515j56d10f2ej55859500c91befbb@mail.gmail.com>
Date: Wed, 30 Jan 2008 21:15:22 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: [PATCH 1/1] [Blackfin] char driver for Blackfin on-chip OTP memory
Cc: "Jiri Slaby" <jirislaby@gmail.com>, "Bryan Wu" <bryan.wu@analog.com>,
       linux-kernel@vger.kernel.org,
       "Mike Frysinger" <michael.frysinger@analog.com>
In-Reply-To: <200801300739.21344.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201689401-2892-1-git-send-email-bryan.wu@analog.com>
	 <47A058B3.6000009@gmail.com>
	 <200801300739.21344.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 8:39 PM, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Wed 30 Jan 2008 06:00, Jiri Slaby pondered:
> > On 01/30/2008 11:36 AM, Bryan Wu wrote:
> > > From: Mike Frysinger <michael.frysinger@analog.com>
> > >
> > > initial char driver for otp memory
> > > (only read supported atm ... needs real examples/docs for write support)
> > >
> > > Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
> > > Signed-off-by: Bryan Wu <bryan.wu@analog.com>
>
> > > +   bfin_otp_class = class_create(THIS_MODULE, "otp");
> > > +   device_create(bfin_otp_class, NULL, bfin_otp_dev_node, "otp");
> >
> > Anyway, wouldn't be easier/better to use misc.c functionality here
> > (misc_register() et al.)?
>
> OTP (one time programmable) memory are not registers, they are small blocks
> (8k bytes) of non violate on chip memory, for storing things that you don't
> want other people to look at via a PCB level probe. (like keys), or things
> that are just helpful - like MAC addresses.
>

Jiri means this OTP char driver can use misc character driver
interface as misc_register().

And one question for Jiri, what is the difference between misc char
driver with other char drivers.
Because we got some other char drivers locally, maybe some day send them out.

Thanks
-Bryan
