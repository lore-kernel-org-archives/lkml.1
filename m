Return-Path: <linux-kernel-owner+w=401wt.eu-S1760279AbXE2ISS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279AbXE2ISS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 04:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbXE2ISJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 04:18:09 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:58033 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbXE2ISI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 04:18:08 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <292C7F80-B80D-4645-8FF5-49BF911398E1@cam.ac.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Makefile question (was [RFC] LZO de/compression support - take 6)
Date: Tue, 29 May 2007 09:17:46 +0100
To: "Nitin Gupta" <nitingupta910@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2007, at 15:34, Nitin Gupta wrote:

> diff --git a/lib/Kconfig b/lib/Kconfig
> index 2e7ae6b..eb95eaa 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -64,6 +64,12 @@ config ZLIB_INFLATE
> config ZLIB_DEFLATE
> 	tristate
>
> +config LZO1X_COMPRESS
> +	tristate
> +
> +config LZO1X_DECOMPRESS
> +	tristate
> +
> #
> # Generic allocator support is selected if needed
> #
> diff --git a/lib/Makefile b/lib/Makefile
> index c8c8e20..448ae37 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -49,6 +49,8 @@ obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
> obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
> obj-$(CONFIG_ZLIB_DEFLATE) += zlib_deflate/
> obj-$(CONFIG_REED_SOLOMON) += reed_solomon/
> +obj-$(CONFIG_LZO1X_COMPRESS) += lzo1x/
> +obj-$(CONFIG_LZO1X_DECOMPRESS) += lzo1x/
>
> obj-$(CONFIG_TEXTSEARCH) += textsearch.o
> obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o

Hey there,

Is this syntax OK for Makefile use? I'm only asking out of personal  
ignorance and because I'd use:

Kconfig:

config LZO1X_COMPRESS
	select LZO1X
	tristate

config LZO1X_DECOMPRESS
	select LZO1X
	tristate

config LZO1X
	tristate (or boolean??)

Makefile:

obj-$(CONFIG_LZO1X) += lzo1x/

Thanks,

Michael-Luke
