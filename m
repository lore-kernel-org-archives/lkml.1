Return-Path: <linux-kernel-owner+w=401wt.eu-S1761964AbYF2PNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964AbYF2PNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 11:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760911AbYF2PMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 11:12:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:57063 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760801AbYF2PLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 11:11:55 -0400
Date: Mon, 30 Jun 2008 00:07:17 +0900
To: joerg.roedel@amd.com
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 34/34] AMD IOMMU: add documentation for kernel
 parameters
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1214508490-29683-35-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-35-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080630000551E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 21:28:10 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Add documentation for the kernel parameters introduced with this driver.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  Documentation/kernel-parameters.txt |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index e07c432..fc8f936 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -271,6 +271,18 @@ and is between 256 and 4096 characters. It is defined in the file
>  	aic79xx=	[HW,SCSI]
>  			See Documentation/scsi/aic79xx.txt.
>  
> +	amd_iommu=	[HW,X86-84]
> +			Pass parameters to the AMD IOMMU driver in the system.
> +			Possible values are:
> +			off     - disable the driver for AMD IOMMU
> +			isolate - enable device isolation (each device, as far
> +			          as possible, will get its own protection
> +			          domain)
> +	amd_iommu_size= [HW,X86-64]
> +			Define the size of the aperture for the AMD IOMMU
> +			driver. Possible values are:
> +			'32M', '64M' (default), '128M', '256M', '512M', '1G'
> +
>  	amijoy.map=	[HW,JOY] Amiga joystick support
>  			Map of devices attached to JOY0DAT and JOY1DAT
>  			Format: <a>,<b>

Documentation/x86_64/boot-options.txt would be a better place?

Probabaly, it would be better to clean up x86_64 IOMMU options.
