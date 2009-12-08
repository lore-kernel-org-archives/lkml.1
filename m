Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZLHHiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZLHHiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZLHHiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:38:13 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45089 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZLHHiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:38:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=HcHCuBcZ8mqwcBBBmuc2SfMYayODGGU37ktjYxg4GDzxh5Eg4Vx3XTsqA2eIeepbu+
         I0DSJXWm2L1+u/Eq/anQOaoC1aCKSAT/17JENtQksi7A9yyotKwrPqSdbVEea0kRMLHq
         Yt14RsjzgQr41mG2ZvgsMwx+axyXlXu/uxFbI=
Subject: Re: [PATCH v8 1/8] MIPS: add subdirectory for platform extension
 drivers
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: akpm@linux-foundation.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <d6bb11d33fe01abd6de945117ce647af73841f00.1260082252.git.wuzhangjin@gmail.com>
References: <cover.1260082252.git.wuzhangjin@gmail.com>
	 <d6bb11d33fe01abd6de945117ce647af73841f00.1260082252.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Tue, 08 Dec 2009 15:37:45 +0800
Message-ID: <1260257865.3315.79.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ralf

I plan to send a new revision of this patchset, Can I get your Acked-by:
for patch 1-3/8?

Thanks!
	Wu Zhangjin

On Sun, 2009-12-06 at 15:01 +0800, Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> It is really hard to split the platform specific subdrivers into
> different subsystems, which will generate lots of duplicated source
> code, break the whole support into several pieces and also will make the
> users be difficult to choose the suitable subdrivers in different
> places.
> 
> So, I did like the forks have done under drivers/platform/x86, created
> the drivers/platform/mips/ for putting the future MIPS netbook/laptop/pc
> extension drivers in.
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> ---
>  drivers/platform/Kconfig      |    4 ++++
>  drivers/platform/mips/Kconfig |   18 ++++++++++++++++++
>  2 files changed, 22 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/platform/mips/Kconfig
> 
> diff --git a/drivers/platform/Kconfig b/drivers/platform/Kconfig
> index 9652c3f..2319c0b 100644
> --- a/drivers/platform/Kconfig
> +++ b/drivers/platform/Kconfig
> @@ -3,3 +3,7 @@
>  if X86
>  source "drivers/platform/x86/Kconfig"
>  endif
> +
> +if MIPS
> +source "drivers/platform/mips/Kconfig"
> +endif
> diff --git a/drivers/platform/mips/Kconfig b/drivers/platform/mips/Kconfig
> new file mode 100644
> index 0000000..2f77693
> --- /dev/null
> +++ b/drivers/platform/mips/Kconfig
> @@ -0,0 +1,18 @@
> +#
> +# MIPS Platform Specific Drivers
> +#
> +
> +menuconfig MIPS_PLATFORM_DEVICES
> +	bool "MIPS Platform Specific Device Drivers"
> +	default y
> +	help
> +	  Say Y here to get to see options for device drivers of various
> +	  MIPS platforms, including vendor-specific netbook/laptop/pc extension
> +	  drivers.  This option alone does not add any kernel code.
> +
> +	  If you say N, all options in this submenu will be skipped and disabled.
> +
> +if MIPS_PLATFORM_DEVICES
> +
> +
> +endif # MIPS_PLATFORM_DEVICES


