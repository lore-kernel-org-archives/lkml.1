Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbZECVz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbZECVz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 17:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZECVzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 17:55:14 -0400
Received: from mga06.intel.com ([134.134.136.21]:38266 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751453AbZECVzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 17:55:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,288,1239001200"; 
   d="scan'208";a="512170449"
Date: Sun, 3 May 2009 23:57:29 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Mark WM8350 mask revision as readable to match
	silicon
Message-ID: <20090503215728.GC3278@sortiz.org>
References: <1241099069-17778-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241099069-17778-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Apr 30, 2009 at 02:44:29PM +0100, Mark Brown wrote:
> No impact unless someone has written additional kernel code.
All 3 patches applied to my for-next branch, thanks.

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8350-regmap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-regmap.c b/drivers/mfd/wm8350-regmap.c
> index 9a4cc95..97d6aad 100644
> --- a/drivers/mfd/wm8350-regmap.c
> +++ b/drivers/mfd/wm8350-regmap.c
> @@ -3186,7 +3186,7 @@ const struct wm8350_reg_access wm8350_reg_io_map[] = {
>  	/*  read    write volatile */
>  	{ 0xFFFF, 0xFFFF, 0xFFFF }, /* R0   - Reset/ID */
>  	{ 0x7CFF, 0x0C00, 0x7FFF }, /* R1   - ID */
> -	{ 0x0000, 0x0000, 0x0000 }, /* R2 */
> +	{ 0x007F, 0x0000, 0x0000 }, /* R2   - ROM Mask ID */
>  	{ 0xBE3B, 0xBE3B, 0x8000 }, /* R3   - System Control 1 */
>  	{ 0xFEF7, 0xFEF7, 0xF800 }, /* R4   - System Control 2 */
>  	{ 0x80FF, 0x80FF, 0x8000 }, /* R5   - System Hibernate */
> -- 
> 1.6.2.4
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
