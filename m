Return-Path: <linux-kernel-owner+w=401wt.eu-S1764964AbXIMS2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764964AbXIMS2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 14:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759495AbXIMS2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 14:28:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:44398 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759436AbXIMS2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 14:28:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZFEjzGP8WjEJu40tIa9K/rnPIKDS8bCclJ3i+hRpIlNo/2Yz+vIDh9GOdZILBNWIqSFjUoVl8wf5Y8+2eoBDRegc83yBO0TWKZvBpTKSPntFNMvbdqrkrtZ9+sKSp6auNl6r+G3UNCQ4C3sdFQNBSP6cdh/Wxwp4Urd04xlweyQ=
Message-ID: <625fc13d0709131128m5a606b6ewe729c1e72f73f9d9@mail.gmail.com>
Date: Thu, 13 Sep 2007 13:28:31 -0500
From: "Josh Boyer" <jwboyer@gmail.com>
To: "Mike Frysinger" <vapier@gentoo.org>
Subject: Re: [patch] update CFI URI n mtd kconfig
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
In-Reply-To: <200709122339.55267.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709122339.55267.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/07, Mike Frysinger <vapier@gentoo.org> wrote:
> Since AMD shunted its flash memory division, the URI in the mtd Kconfig is now
> broken, so the attached patch points people to Wikipedia.
>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> diff --git a/drivers/mtd/chips/Kconfig b/drivers/mtd/chips/Kconfig
> index 479d32b..980117a 100644
> --- a/drivers/mtd/chips/Kconfig
> +++ b/drivers/mtd/chips/Kconfig
> @@ -11,8 +11,8 @@ config MTD_CFI
>           AMD and other flash manufactures that provides a universal method
>           for probing the capabilities of flash devices. If you wish to
>           support any device that is CFI-compliant, you need to enable this
> -         option. Visit <http://www.amd.com/products/nvd/overview/cfi.html>
> -         for more information on CFI.
> +         option. For more information on CFI, visit:
> +         <http://wikipedia.org/wiki/Common_Flash_Memory_Interface>

Erm, I'd rather not point to wikipedia.  Can you change it to point to:

http://www.intel.com/design/flash/swb/cfi.htm

instead?

josh
