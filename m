Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbZBFNzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbZBFNzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbZBFNzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:55:31 -0500
Received: from mga07.intel.com ([143.182.124.22]:10703 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754238AbZBFNza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:55:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,391,1231142400"; 
   d="scan'208";a="107941563"
Date: Fri, 6 Feb 2009 14:57:53 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: Mark WM835x USB_SLV_500MA bit as accessible
Message-ID: <20090206135753.GC3341@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1232727516-5049-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232727516-5049-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 04:18:34PM +0000, Mark Brown wrote:
> Brings the data table into sync with the silicon.
All 3 patches applied, thanks.

Cheers,
Samuel.

 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8350-regmap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-regmap.c b/drivers/mfd/wm8350-regmap.c
> index 68887b8..9a4cc95 100644
> --- a/drivers/mfd/wm8350-regmap.c
> +++ b/drivers/mfd/wm8350-regmap.c
> @@ -3188,7 +3188,7 @@ const struct wm8350_reg_access wm8350_reg_io_map[] = {
>  	{ 0x7CFF, 0x0C00, 0x7FFF }, /* R1   - ID */
>  	{ 0x0000, 0x0000, 0x0000 }, /* R2 */
>  	{ 0xBE3B, 0xBE3B, 0x8000 }, /* R3   - System Control 1 */
> -	{ 0xFCF7, 0xFCF7, 0xF800 }, /* R4   - System Control 2 */
> +	{ 0xFEF7, 0xFEF7, 0xF800 }, /* R4   - System Control 2 */
>  	{ 0x80FF, 0x80FF, 0x8000 }, /* R5   - System Hibernate */
>  	{ 0xFB0E, 0xFB0E, 0x0000 }, /* R6   - Interface Control */
>  	{ 0x0000, 0x0000, 0x0000 }, /* R7 */
> -- 
> 1.5.6.5
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
