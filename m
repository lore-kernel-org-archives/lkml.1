Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbXF0IoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbXF0IoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 04:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXF0IoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 04:44:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:3652 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbXF0IoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 04:44:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OY9jJynhIHp3OjHGPGUHNP9Tx4K6F1GtfRR6JcmgVX+Ae3TOGkzRvS1k7TlWb/LiVVfjC2eiYJx/cWDJq2b01nag5mXBxWQs6rv48XZEiJorFsQc3NOIFUB1wFwXhqkFtZA2sGzizHte14F7pbbpOlrxe5BiMvtzcq/K/eI0rKw=
Message-ID: <5d5443650706270144l2d905d2h142617d01f515785@mail.gmail.com>
Date: Wed, 27 Jun 2007 14:14:08 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 01/17] OMAP: Add TI OMAP framebuffer driver
Cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       akpm@linux-foundation.org, "Tony Lindgren" <tony@atomide.com>,
       imre.deak@solidboot.com, juha.yrjola@solidboot.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070626165003.GA22389@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d5443650706260533r218c05b1u5d4336015c4a4a9b@mail.gmail.com>
	 <20070626165003.GA22389@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On 6/26/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> diff --git a/drivers/video/omap/Makefile b/drivers/video/omap/Makefile
> new file mode 100644
> index 0000000..5aa7175
> --- /dev/null
> +++ b/drivers/video/omap/Makefile
> @@ -0,0 +1,10 @@
> +#
> +# Makefile for the new OMAP framebuffer device driver
> +#
> +
> +obj-$(CONFIG_FB_OMAP) += omapfb.o
> +
> +objs-yy := omapfb_main.o
> +
> +omapfb-objs := $(objs-yy)
> +
>
> This looks strangs.
> Please use:
> obj-$(CONFIG_FB_OMAP) += omapfb.o
>
> omapfb-y := omapfb_main.o
>
> Or even better rename your .c file to omapfb.c then
> you only need to use:
> obj-$(CONFIG_FB_OMAP) += omapfb.o
>

Thanx for the review. I will incorporate your suggestions into the
next update of fb patches.

-- 
--Trilok Soni
