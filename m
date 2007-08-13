Return-Path: <linux-kernel-owner+w=401wt.eu-S938214AbXHMUAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938214AbXHMUAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970597AbXHMT7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:59:02 -0400
Received: from mx0.karneval.cz ([81.27.192.14]:55023 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965938AbXHMT67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:58:59 -0400
X-Greylist: delayed 1645 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 15:58:59 EDT
From: Pavel Pisa <ppisa@pikron.com>
Organization: PiKRON Ltd.
To: joe@perches.com
Subject: Re: [PATCH] [322/2many] MAINTAINERS - MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
Date: Mon, 13 Aug 2007 21:29:22 +0200
User-Agent: KMail/1.9.4
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <46bffaea.9eZfjjbX0RTIxLG/%joe@perches.com>
In-Reply-To: <46bffaea.9eZfjjbX0RTIxLG/%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708132129.23407.ppisa@pikron.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 August 2007 08:32, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>

By the way, I am hunting write timeouts bugs now.
I expect it is some MX1 SDHC hardware-driver
interaction problem. Any help appreciated.

I have patch implementing specialized imxmmc
logger which writes couple of last 64 SDHC events
before bug occurred.

Best wishes

             Pavel Pisa

> diff --git a/MAINTAINERS b/MAINTAINERS
> index aeb86e6..ddff41d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3099,6 +3099,7 @@ M:	ppisa@pikron.com
>  L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
>  W:	http://mmc.drzeus.cx/wiki/Controllers/Freescale/SDHC
>  S:	Maintained
> +F:	drivers/mmc/host/imxmmc.*
>
>  MOUSE AND MISC DEVICES [GENERAL]
>  P:	Alessandro Rubini


