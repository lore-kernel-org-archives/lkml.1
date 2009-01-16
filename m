Return-Path: <linux-kernel-owner+w=401wt.eu-S935806AbZAPADc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935806AbZAPADc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935179AbZAPACh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:02:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935225AbZAPACf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:02:35 -0500
Date: Thu, 15 Jan 2009 16:02:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Mark WM835x USB_SLV_500MA bit as accessible
Message-Id: <20090115160200.1d6a0c93.akpm@linux-foundation.org>
In-Reply-To: <1231944901-4901-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1231944901-4901-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 14:55:01 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

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

Why?
