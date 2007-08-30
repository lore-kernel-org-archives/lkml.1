Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbXH3Opi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbXH3Opi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761997AbXH3Oon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:44:43 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:46754 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761989AbXH3Ool (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:44:41 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Thu, 30 Aug 2007 08:45:02 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Andres Salomon" <dilinger@queued.net>
cc: jayakumar.alsa@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, info-linux@geode.amd.com
Subject: Re: ALSA: cs5535audio: fix ACC_BM[x]_CMD register handling
Message-ID: <20070830144502.GK5851@cosmic.amd.com>
References: <20070829233043.42d24ff7.dilinger@queued.net>
MIME-Version: 1.0
In-Reply-To: <20070829233043.42d24ff7.dilinger@queued.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 30 Aug 2007 14:43:54.0946 (UTC)
 FILETIME=[30884A20:01C7EB14]
X-WSS-ID: 6AC80839CG8894919-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/07 23:30 -0400, Andres Salomon wrote:
> 
> ACcording to 6.3.2.7 of the cs5535/cs5536 data sheets, the ACC_BM[x]_CMD
> registers are only 8 bits wide.  This driver treats them as 32 bits wide,
> and also has bits in the wrong place.  Simple fix to the definitions.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
> ---
> 
>  sound/pci/cs5535audio/cs5535audio.h |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
> index c7a2044..516219a 100644
> --- a/sound/pci/cs5535audio/cs5535audio.h
> +++ b/sound/pci/cs5535audio/cs5535audio.h
> @@ -62,11 +62,11 @@
>  #define EOP				(1<<0)
>  #define BM_EOP_ERR			(1<<1)
>  /* ACC_BMX_CTL */
> -#define BM_CTL_EN			0x00000001
> -#define BM_CTL_PAUSE			0x00000011
> -#define BM_CTL_DIS			0x00000000
> -#define BM_CTL_BYTE_ORD_LE		0x00000000
> -#define BM_CTL_BYTE_ORD_BE		0x00000100
> +#define BM_CTL_EN			0x01
> +#define BM_CTL_PAUSE			0x03
> +#define BM_CTL_DIS			0x00
> +#define BM_CTL_BYTE_ORD_LE		0x00
> +#define BM_CTL_BYTE_ORD_BE		0x04
>  /* cs5535 specific ac97 codec register defines */
>  #define CMD_MASK			0xFF00FFFF
>  #define CMD_NEW				0x00010000
> 
> 

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


