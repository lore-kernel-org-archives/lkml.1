Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbZGGPGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbZGGPGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbZGGPFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:05:54 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:1248
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752977AbZGGPFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:05:53 -0400
Message-ID: <4A53644E.2090205@panasas.com>
Date: Tue, 07 Jul 2009 18:05:50 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <Jens.Axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Make SCSI SG v4 driver enabled by default now since udev
 depends on it.
References: <1246978255-19407-1-git-send-email-john@stoffel.org>
In-Reply-To: <1246978255-19407-1-git-send-email-john@stoffel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jul 2009 15:05:53.0036 (UTC) FILETIME=[6BD59CC0:01C9FF14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2009 05:50 PM, John Stoffel wrote:
> Signed-off-by: John Stoffel <john@stoffel.org>
> ---
>  block/Kconfig |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index e7d1278..22bf6eb 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -46,8 +46,8 @@ config LBD
>  
>  config BLK_DEV_BSG
>  	bool "Block layer SG support v4 (EXPERIMENTAL)"

Please also remove the (EXPERIMENTAL) from the prompt as well

> -	depends on EXPERIMENTAL
> -	---help---
> +	default y
> +	help
>  	  Saying Y here will enable generic SG (SCSI generic) v4 support
>  	  for any block device.
>  
> @@ -57,7 +57,7 @@ config BLK_DEV_BSG
>  	  protocols (e.g. Task Management Functions and SMP in Serial
>  	  Attached SCSI).
>  
> -	  If unsure, say N.
> +	  If unsure, say Y.
>  
>  config BLK_DEV_INTEGRITY
>  	bool "Block layer data integrity support"

Thanks I needed that too.

BTW distro(s) have been shipping with it on for ages

Boaz
