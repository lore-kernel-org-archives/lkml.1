Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbXIFMGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbXIFMGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756462AbXIFMGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:06:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:59746 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757149AbXIFMGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:06:15 -0400
Subject: Re: [PATCH 3/4] radeonfb: fix setting of PPLL_REF_DIV for RV370
	5B60
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: aherrman@arcor.de
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070904110000.GG7320@devil>
References: <20070904110000.GG7320@devil>
Content-Type: text/plain
Date: Tue, 04 Sep 2007 15:47:03 +0200
Message-Id: <1188913623.5972.152.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-04 at 13:00 +0200, aherrman@arcor.de wrote:
> As observed with various Radeon X300: console goes blank
> without fixing setting of PPLL_REF_DIV.
> 
> Signed-off-by: Andreas Herrmann <aherrman@arcor.de>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
>  drivers/video/aty/radeon_base.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
> index f672c0c..71b0c17 100644
> --- a/drivers/video/aty/radeon_base.c
> +++ b/drivers/video/aty/radeon_base.c
> @@ -1287,7 +1287,8 @@ static void radeon_write_pll_regs(struct radeonfb_info *rinfo, struct radeon_reg
>  	if (rinfo->family == CHIP_FAMILY_R300 ||
>  	    rinfo->family == CHIP_FAMILY_RS300 ||
>  	    rinfo->family == CHIP_FAMILY_R350 ||
> -	    rinfo->family == CHIP_FAMILY_RV350) {
> +	    rinfo->family == CHIP_FAMILY_RV350 ||
> +	    rinfo->family == CHIP_FAMILY_RV380 ) {
>  		if (mode->ppll_ref_div & R300_PPLL_REF_DIV_ACC_MASK) {
>  			/* When restoring console mode, use saved PPLL_REF_DIV
>  			 * setting.

