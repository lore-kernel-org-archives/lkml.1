Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbYDWUCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbYDWUCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 16:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYDWUCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 16:02:08 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:23392 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbYDWUCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 16:02:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eIwHnZ8NLUcOmLpCFHezfAoj2GLRFW5rVys2FsOs4zof4mbsthVFkt1b7YJbucqOvcUrlCvYC7fSZE22hfKF/7HpHn1k4TDW4wZ3sxrA5BDlQaKlmoV0OyYzvstuK3F2mQcw0JWBSs8hUgrFl13zuxIpx4eW9YL628coVcv+KHQ=
Message-ID: <74d0deb30804231302v1526d018v8d39cb17d231f25f@mail.gmail.com>
Date: Wed, 23 Apr 2008 22:02:04 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] mfd: kconfig exposing unbuildable driver
Cc: "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <20080422203334.GA9809@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1208895950.24124.9.camel@brick>
	 <20080422203334.GA9809@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 10:33 PM, Russell King
<rmk+lkml@arm.linux.org.uk> wrote:
> That was my initial approach as well, which got shot down by Andrew
>  Morton and others as being unacceptable.

'Shot down' is a bit harsh. I just argued that technically the driver
does not depend on ARM (and neither does the ASIC, most probably).
On the other hand, AFAIK it is proprietary HTC silicon only found in a
handful of their devices, all of which are PXA2xx based.

>  On Tue, Apr 22, 2008 at 01:25:50PM -0700, Harvey Harrison wrote:
>  > Limit this driver to ARCH_PXA, noticed by breakage on allyesconfig
>  > builds on 32-bit x86.
>  >
>  > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>  > ---
>  > Linus, please apply and Russell can fix it up however he likes later
>  > in the week.  Many people are hitting this.
>  >
>  >  drivers/mfd/Kconfig |    1 +
>  >  1 files changed, 1 insertions(+), 0 deletions(-)
>  >
>  > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>  > index 2566479..bd29c61 100644
>  > --- a/drivers/mfd/Kconfig
>  > +++ b/drivers/mfd/Kconfig
>  > @@ -32,6 +32,7 @@ config HTC_EGPIO
>  >
>  >  config HTC_PASIC3
>  >       tristate "HTC PASIC3 LED/DS1WM chip support"
>  > +     depends on ARCH_PXA
>  >       help
>  >         This core driver provides register access for the LED/DS1WM
>  >         chips labeled "AIC2" and "AIC3", found on HTC Blueangel and
>  > --
>  > 1.5.5.144.g3e42
>  >
>  >
>  >
>
>  --
>  Russell King
>   Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>   maintainer of:
>
>
> --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>

regards
Philipp
