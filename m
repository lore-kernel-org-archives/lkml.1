Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbYJMNiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbYJMNiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761766AbYJMNh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:37:57 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:51473 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762633AbYJMNh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:37:56 -0400
Date: Mon, 13 Oct 2008 15:37:52 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: Fix warning in WM8350
Message-ID: <20081013133752.GB4759@localdomain>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20081013113509.GA31973@rakim.wolfsonmicro.main> <1223897792-32031-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1223897792-32031-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223897792-32031-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 12:36:32PM +0100, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Samuel Ortiz <sameo@openedhand.com>

> ---
>  drivers/mfd/wm8350-core.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> index 8554855..35f4557 100644
> --- a/drivers/mfd/wm8350-core.c
> +++ b/drivers/mfd/wm8350-core.c
> @@ -1161,7 +1161,6 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
>  {
>  	int ret = -EINVAL;
>  	u16 id1, id2, mask, mode;
> -	int i;
>  
>  	/* get WM8350 revision and config mode */
>  	wm8350->read_dev(wm8350, WM8350_RESET_ID, sizeof(id1), &id1);
> -- 
> 1.5.6.5
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
