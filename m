Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbXF1Kf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbXF1Kf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 06:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbXF1Kfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 06:35:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:11242 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbXF1Kft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 06:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ETZNdIRW3gGNEsBgIQ1DCgWitgeJyB2SXsJQ0HeCys18PERw0T0qj8XhF7ls6ic9/pd4unN2m1Mcl3AGQXmCvPKCLTwHBHBuVuXQZP58Pgy5IoDzwP0HzjPle4HeXtDCL7Kep4LEw/bn5LOAecALELvNtof6pdlS7CqPftsRx7E=
Message-ID: <a781481a0706280335l5ac5e0e1w6c29922598b7416f@mail.gmail.com>
Date: Thu, 28 Jun 2007 16:05:48 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Anders Blomdell" <anders.blomdell@control.lth.se>
Subject: Re: [PATCH] Documentation/firmware_class/firmware_sample_driver.c
Cc: linux-kernel@vger.kernel.org, "Manuel Estrada Sainz" <ranty@debian.org>
In-Reply-To: <46827B20.6000501@control.lth.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46827B20.6000501@control.lth.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[ It's good that you're trying to fix this, code in documentation should
be setting standards, clearly. ]

On 6/27/07, Anders Blomdell <anders.blomdell@control.lth.se> wrote:
> [...]
> Minor modifications to make the example load and unload without Oops
> [...]
>  static int sample_init(void)
>  {
> -       device_initialize(&ghost_device);
> +       device_register(&ghost_device);
>         /* since there is no real hardware insertion I just call the
>          * sample probe functions here */
> -       sample_probe_specific();
> +       /* sample_probe_specific(); */
>         sample_probe_default();
> -       sample_probe_async();
> +       /*sample_probe_async();*/
>         return 0;
>  }

But IMO the above functions should be *fixed* to work properly instead
of simply commenting them out. If they are un-fixable, why even keep
the broken code in that file (only to mislead readers in future?). You
might as well remove those calls (and the function definitions) completely.
Best would be to fix them, of course.

My Rs. 0.02,
Satyam
