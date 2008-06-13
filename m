Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbYFMMHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbYFMMHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 08:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYFMMHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 08:07:35 -0400
Received: from xspect.dk ([212.97.129.87]:48632 "EHLO xspect.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbYFMMHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 08:07:34 -0400
X-Greylist: delayed 1650 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jun 2008 08:07:34 EDT
Date: Fri, 13 Jun 2008 13:40:02 +0200
From: "Klaus S. Madsen" <ubuntu@hjernemadsen.org>
To: maximilian attems <max@stro.at>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       Chuck Short <zulcss@ubuntu.com>,
       Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH] hdaps add support for various IBM thinkpads R61/T61/T61P
Message-ID: <20080613114002.GJ30713@42.dk>
References: <1213356407-1220-1-git-send-email-max@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213356407-1220-1-git-send-email-max@stro.at>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 13:26:47 +0200, maximilian attems wrote:
> last missing hdaps ubuntu sync.
> add the ubuntu entries in alphabetical order.
> original authors below on Cc.
> 
> Cc: Klaus S. Madsen <ubuntu@hjernemadsen.org>
> Cc: Chuck Short <zulcss@ubuntu.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: maximilian attems <max@stro.at>
> ---
>  drivers/hwmon/hdaps.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/hdaps.c b/drivers/hwmon/hdaps.c
> index 26df06f..e07c712 100644
> --- a/drivers/hwmon/hdaps.c
> +++ b/drivers/hwmon/hdaps.c
> @@ -515,6 +515,7 @@ static struct dmi_system_id __initdata hdaps_whitelist[] = {
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R50"),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R51"),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R52"),
> +	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R61"),
>  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i"),
>  	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T41p"),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T41"),
> @@ -523,6 +524,8 @@ static struct dmi_system_id __initdata hdaps_whitelist[] = {
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
>  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60"),
>  	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61"),
> +	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T61"),
> +	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T61P"),
I would suspect that this part of the patch is unnecessary. It would be
strange if there are any T61's where the manufacturer is IBM, instead of
LENOVO, since the T60 is older and has the manufacturer listed as
LENOVO, and no entry exists for IBM.

But according to the comment at the top of the struct, the second line
(the T61P part) is unnecessary, as a T61p already would be matched by
the T61 line. 

-- 
Kind regards,
	Klaus S. Madsen
