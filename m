Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbXJ3ADb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbXJ3ADb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbXJ3ADY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:03:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37660 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbXJ3ADX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:03:23 -0400
Message-ID: <472674B0.9080001@zytor.com>
Date: Mon, 29 Oct 2007 17:02:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       tibor.osztodi@bbraun.com, linux-info@geode.amd.com
Subject: Re: [PATCH] [LXFB] Use the correct MSR number for panel support
References: <20071026145301.14168.19412.stgit@cosmic.amd.com>
In-Reply-To: <20071026145301.14168.19412.stgit@cosmic.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse wrote:
> From: Jordan Crouse <jordan.crouse@amd.com>
> 
> A relatively recent version of the Geode LX datasheet listed the wrong
> address for one of the MSRs that controls TFT panels, resulting in 
> breakage.  This patch corrects the MSR address.
> 
> Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
> ---
> 
>  drivers/video/geode/lxfb.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/geode/lxfb.h b/drivers/video/geode/lxfb.h
> index 6c227f9..ca13c48 100644
> --- a/drivers/video/geode/lxfb.h
> +++ b/drivers/video/geode/lxfb.h
> @@ -33,7 +33,7 @@ void lx_set_palette_reg(struct fb_info *, unsigned int, unsigned int,
>  
>  #define MSR_LX_GLD_CONFIG    0x48002001
>  #define MSR_LX_GLCP_DOTPLL   0x4c000015
> -#define MSR_LX_DF_PADSEL     0x48000011
> +#define MSR_LX_DF_PADSEL     0x48002011
>  #define MSR_LX_DC_SPARE      0x80000011
>  #define MSR_LX_DF_GLCONFIG   0x48002001
>  

Please put MSR indicies in <asm-x86/msr-index.h> and/or a separate 
include file.

	-hpa
