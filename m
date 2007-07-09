Return-Path: <linux-kernel-owner+w=401wt.eu-S1760009AbXGIXgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbXGIXgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 19:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbXGIXgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 19:36:14 -0400
Received: from xenotime.net ([66.160.160.81]:55819 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757481AbXGIXgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 19:36:13 -0400
Date: Mon, 9 Jul 2007 16:39:49 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Matt LaPlante <kernel1@cyberdogtech.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] 2.6.22 - Documentation Cleanup
Message-Id: <20070709163949.85a4d133.rdunlap@xenotime.net>
In-Reply-To: <20070709134516.f5e7dc07.kernel1@cyberdogtech.com>
References: <20070709134516.f5e7dc07.kernel1@cyberdogtech.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007 13:45:16 -0400 Matt LaPlante wrote:

> Fix misc small issues/typos/grammar in Documentation txts for 2.6.22.
> 
> Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
> --

patching file Documentation/input/iforce-protocol.txt
Hunk #1 FAILED at 7.
Hunk #2 FAILED at 151.
Hunk #3 FAILED at 239.
3 out of 3 hunks FAILED -- saving rejects to file Documentation/input/iforce-protocol.txt.rej


> diff -ru a/Documentation/arm/Samsung-S3C24XX/DMA.txt b/Documentation/arm/Samsung-S3C24XX/DMA.txt
> --- a/Documentation/arm/Samsung-S3C24XX/DMA.txt	2007-07-08 19:32:17.000000000 -0400
> +++ b/Documentation/arm/Samsung-S3C24XX/DMA.txt	2007-07-08 23:11:21.000000000 -0400
> @@ -17,15 +17,15 @@
>     channels to all sources, which means that some devices
>     have a restricted number of channels that can be used.
>  
> -   To allow flexibilty for each cpu type and board, the
> -   dma code can be given an dma ordering structure which
> +   To allow flexibility for each cpu type and board, the
> +   DMA code can be given a DMA ordering structure which
>     allows the order of channel search to be specified, as
>     well as allowing the prohibition of certain claims.

Why uppercase DMA and not cpu?

>     struct s3c24xx_dma_order has a list of channels, and
> -   each channel within has a slot for a list of dma
> -   channel numbers. The slots are searched in order, for
> -   the presence of a dma channel number with DMA_CH_VALID
> +   each channel within has a slot for a list of DMA
> +   channel numbers. The slots are searched in order for
> +   the presence of a DMA channel number with DMA_CH_VALID
>     orred in.
>  
>     If the order has the flag DMA_CH_NEVER set, then after
> @@ -33,8 +33,8 @@
>     found channel, thus denying the request.
>  
>     A board support file can call s3c24xx_dma_order_set()
> -   to register an complete ordering set. The routine will
> -   copy the data, so the original can be discared with
> +   to register a complete ordering set. The routine will
> +   copy the data, so the original can be discarded with
>     __initdata.
>  
>  
> diff -ru a/Documentation/input/iforce-protocol.txt b/Documentation/input/iforce-protocol.txt
> --- a/Documentation/input/iforce-protocol.txt	2007-07-08 19:32:17.000000000 -0400
> +++ b/Documentation/input/iforce-protocol.txt	2007-07-08 22:26:12.000000000 -0400
> @@ -239,7 +239,7 @@
>  3. Play the effect, and watch what happens on the spy screen.
>  
>  A few words about ComPortSpy:
> -At first glance, this soft seems, hum, well... buggy. In fact, data appear with a few seconds latency. Personnaly, I restart it every time I play an effect.
> +At first glance, this soft seems, hum, well... buggy. In fact, data appear with a few seconds latency. Personally, I restart it every time I play an effect.

Those lines are too long.

>  Remember it's free (as in free beer) and alpha!
>  
>  ** URLS **

> diff -ru a/Documentation/scsi/ibmmca.txt b/Documentation/scsi/ibmmca.txt
> --- a/Documentation/scsi/ibmmca.txt	2007-07-08 19:32:17.000000000 -0400
> +++ b/Documentation/scsi/ibmmca.txt	2007-07-09 12:47:52.000000000 -0400
> @@ -72,12 +72,12 @@
>     1 Abstract
>     ----------
>     This README-file describes the IBM SCSI-subsystem low level driver for 
> -   Linux. The descriptions which were formerly kept in the source-code have 
> -   been taken out to this file to easify the codes' readability. The driver 
> +   Linux. The descriptions which were formerly kept in the source code have 
> +   been taken out of this file to simplify the codes readability. The driver 

                                                  code's

and that line ends with a space.  There are several new patch lines
that end with a space.  Please check/remove those trailing spaces.

>     description has been updated, as most of the former description was already
>     quite outdated. The history of the driver development is also kept inside 
>     here. Multiple historical developments have been summarized to shorten the 
> -   textsize a bit. At the end of this file you can find a small manual for 
> +   text size a bit. At the end of this file you can find a small manual for 
>     this driver and hints to get it running on your machine.
>  
>     2 Driver Description
> @@ -186,7 +186,7 @@
>     between 0 and 7). The IBM SCSI-2 F/W adapter offers this on up to two
>     busses and provides support for 30 logical devices at the same time, where
>     in wide-addressing mode you can have 16 puns with 32 luns on each device.
> -   This section dexribes you the handling of devices on non-F/W adapters.
> +   This section describes the handling of devices on non-F/W adapters.
>     Just imagine, that you can have 16 * 32 = 512 devices on a F/W adapter
>     which means a lot of possible devices for such a small machine.
>  
> @@ -819,7 +819,7 @@
>     - Michael Lang
>     
>     July 17, 2000 (v3.2pre8)
> -   A long period of collecting bugreports from all corners of the world
> +   A long period of collecting bug reports from all corners of the world
>     now lead to the following corrections to the code:

          leads

>     1) SCSI-2 F/W support crashed with a COMMAND ERROR. The reason for this 
>        was that it is possible to disable Fast-SCSI for the external bus.
> @@ -1188,7 +1188,7 @@
>  	and 15 get ignored by the driver & adapter!
>       Q: I have a 9595 and I get a NMI during heavy SCSI I/O e.g. during fsck.
>          A COMMAND ERROR is reported and characters on the screen are missing.
> -	Warm reboot is not possible. Things look like quite weired.
> +	Warm reboot is not possible. Things look like quite weird.

                                            delete "like"

>       A: Check the processor type of your 9595. If you have an 80486 or 486DX-2
>          processor complex on your mainboard and you compiled a kernel that
>  	supports 80386 processors, it is possible, that the kernel cannot
> @@ -1261,7 +1261,7 @@
>     some e-mail directly, but at least with the same information as required by
>     the formular.
>     
> -   If you have extensive bugreports, including Ooops messages and 
> +   If you have extensive bug reports, including Ooops messages and 

                                                   Oops

>     screen-shots, please feel free to send it directly to the address

                                             them

>     of the maintainer, too. The current address of the maintainer is:
>     

> diff -ru a/Documentation/sound/alsa/soc/overview.txt b/Documentation/sound/alsa/soc/overview.txt
> --- a/Documentation/sound/alsa/soc/overview.txt	2007-07-08 19:32:17.000000000 -0400
> +++ b/Documentation/sound/alsa/soc/overview.txt	2007-07-09 12:30:56.000000000 -0400
> @@ -2,7 +2,7 @@
>  ==============
>  
>  The overall project goal of the ALSA System on Chip (ASoC) layer is to provide
> -better ALSA support for embedded system on chip procesors (e.g. pxa2xx, au1x00,
> +better ALSA support for embedded system on chip processors (e.g. pxa2xx, au1x00,

                                    system-on-chip (?)

>  iMX, etc) and portable audio codecs. Currently there is some support in the
>  kernel for SoC audio, however it has some limitations:-
>  

Rest of looks good to me.

Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
