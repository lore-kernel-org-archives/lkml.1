Return-Path: <linux-kernel-owner+w=401wt.eu-S934261AbXLRCng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934261AbXLRCng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 21:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbXLRCn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 21:43:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:28699 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbXLRCn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 21:43:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YJF3t6wmHmQEPs4rk3XPRBbB1IfCwex8w2RjwaRKGi3Vt8b2pX6ImUyxo7CEqQm6P+FqrfoIYBi/o5G3rjQaSmDNsKqyoAnDEV2hjk904wmsXuM4mEp4O/fngGK4jDrUSSv9Dfe9RWFPMuZLJI71rCNaDB+oPxlpbYTxjaAv03E=
Message-ID: <9e4733910712171843u579c34efia53d0571a782dd19@mail.gmail.com>
Date: Mon, 17 Dec 2007 21:43:26 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Makefile
In-Reply-To: <20071218023928.8530.25171.stgit@terra.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071218023913.8530.46661.stgit@terra.home>
	 <20071218023928.8530.25171.stgit@terra.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore this patch, I forgot to remove it before mailing the series.

On 12/17/07, Jon Smirl <jonsmirl@gmail.com> wrote:
> Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
>
> Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
> ---
>
>  Makefile |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
>
> diff --git a/Makefile b/Makefile
> index c1825aa..15ada3f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -35,6 +35,9 @@ MAKEFLAGS += -rR --no-print-directory
>  # To put more focus on warnings, be less verbose as default
>  # Use 'make V=1' to see the full commands
>
> +ARCH=powerpc
> +CROSS_COMPILE=powerpc-603e-linux-gnu-
> +
>  ifdef V
>    ifeq ("$(origin V)", "command line")
>      KBUILD_VERBOSE = $(V)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Jon Smirl
jonsmirl@gmail.com
