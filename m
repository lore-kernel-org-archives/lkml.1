Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbYA3Nlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbYA3Nlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759950AbYA3Nlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:41:36 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:6040 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759904AbYA3Nle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:41:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dJgUnKKqv7iHksvWhoiwmNHiSY2Ii0Hs+1z7wid0GKOHIW1ajhieLodAncrVIeUA0bLcg/cO7npto0BDZIHAk4VngaW3iULhmuOM+ekxqS1jIdFNrjdEXJSGSxwKYW+MHQjcLmDCh7fiJhjZw3Ec+0TXG0VufNqTSzHEx63UCMQ=
Message-ID: <8bd0f97a0801300541k1f4b1e79ica144e445ba3c6c2@mail.gmail.com>
Date: Wed, 30 Jan 2008 08:41:33 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] [Blackfin] char driver for Blackfin on-chip OTP memory
Cc: "Bryan Wu" <bryan.wu@analog.com>, linux-kernel@vger.kernel.org,
       "Mike Frysinger" <michael.frysinger@analog.com>
In-Reply-To: <47A07DCE.5010808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201689401-2892-1-git-send-email-bryan.wu@analog.com>
	 <47A058B3.6000009@gmail.com>
	 <8bd0f97a0801300519g22c5b66fjcba22a027e7043cc@mail.gmail.com>
	 <47A07DCE.5010808@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 8:38 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 01/30/2008 02:19 PM, Mike Frysinger wrote:
> > On Jan 30, 2008 6:00 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> >> On 01/30/2008 11:36 AM, Bryan Wu wrote:
> >>> +     ret = cdev_add(&bfin_otp_cdev, bfin_otp_dev_node, 1);
> >>> +     if (ret) {
> >>> +             unregister_chrdev_region(bfin_otp_dev_node, 1);
> >>> +             printk(KERN_ERR PFX "unable to register char device\n");
> >>> +             return ret;
> >>> +     }
> >>> +
> >>> +     bfin_otp_class = class_create(THIS_MODULE, "otp");
> >>> +     device_create(bfin_otp_class, NULL, bfin_otp_dev_node, "otp");
> >> Anyway, wouldn't be easier/better to use misc.c functionality here
> >> (misc_register() et al.)?
> >
> > probably ... i just didnt want to statically allocate a number in the
> > range that would be Blackfin specific ...
>
> MISC_DYNAMIC_MINOR is definitely your friend ;).

ah, great ... i'll check it out then, thanks
-mike
