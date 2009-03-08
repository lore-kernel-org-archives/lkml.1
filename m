Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZCHVGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZCHVGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 17:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZCHVGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 17:06:34 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:42924 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbZCHVGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 17:06:34 -0400
Date: Sun, 8 Mar 2009 22:06:25 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Vladimir Botka <vbotka@suse.cz>, mmarek@suse.cz
Subject: Re: hp_accel: add two more axis information
Message-ID: <20090308210625.GC13309@buzzloop.caiaq.de>
References: <20090308202817.GA27465@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090308202817.GA27465@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 10:03:30PM +0100, Pavel Machek wrote:
> Add two more laptops to whitelist.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> 
> diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
> index 29c83b5..448a462 100644
> --- a/drivers/hwmon/hp_accel.c
> +++ b/drivers/hwmon/hp_accel.c
> @@ -187,6 +187,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
>  	AXIS_DMI_MATCH("NC2510", "HP Compaq 2510", y_inverted),
>  	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
>  	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
> +	AXIS_DMI_MATCH("HP2140", "HP 2140", xy_swap_inverted),
>  	AXIS_DMI_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
>  	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
>  	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
> @@ -201,6 +202,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
>  			PRODUCT_NAME, "HP Pavilion dv5",
>  			BOARD_NAME, "3600",
>  			y_inverted),
> +	AXIS_DMI_MATCH("DV7", "HP Pavilion dv7", x_inverted),
>  	{ NULL, }
>  /* Laptop models without axis info (yet):
>   * "NC6910" "HP Compaq 6910"

Does this apply on top of my recent ACPI resolve patches? Could you test
the latest versions already?

Daniel

