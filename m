Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZBSRRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZBSRRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 12:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZBSRRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 12:17:07 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:20777 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZBSRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 12:17:06 -0500
Date: Thu, 19 Feb 2009 18:16:56 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rlove@rlove.org, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Frank Seidel <frank@f-seidel.de>, multinymous@gmail.com,
       Frank Seidel <fseidel@suse.de>
Subject: Re: [PATCH] hwmon/hdaps: Fix bug 7154 adaption for Thinkpad X41
Message-ID: <20090219181656.7c6061e1@hyperion.delvare>
In-Reply-To: <499D53D9.6090407@suse.de>
References: <499569A9.5030202@suse.de>
	<499807B4.1050606@suse.de>
	<4998120C.3030808@suse.de>
	<20090215153735.25ee8b05@hyperion.delvare>
	<499D53D9.6090407@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Frank,

On Thu, 19 Feb 2009 13:43:05 +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> Fix for kernel.org bug #7154:hdaps inversion of
> actual Thinkpad X41's Y-axis.
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/hwmon/hdaps.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/hwmon/hdaps.c
> +++ b/drivers/hwmon/hdaps.c
> @@ -527,7 +527,7 @@ static struct dmi_system_id __initdata h
>  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61p", HDAPS_BOTH_AXES),
>  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61", HDAPS_BOTH_AXES),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X40"),
> -	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X41"),
> +	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad X41", HDAPS_Y_AXIS),
>  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60", HDAPS_BOTH_AXES),
>  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61s", HDAPS_BOTH_AXES),
>  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61", HDAPS_BOTH_AXES),
> 

Applied, thanks.

-- 
Jean Delvare
