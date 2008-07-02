Return-Path: <linux-kernel-owner+w=401wt.eu-S1762957AbYGBI5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762957AbYGBI5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYGBI5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:57:14 -0400
Received: from trinity.fluff.org ([89.145.97.151]:43535 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbYGBI5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:57:12 -0400
Date: Wed, 2 Jul 2008 09:56:56 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, kay.sievers@vrfy.org,
       lkml <linux-kernel@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 2.6.26-rc8] parport: fix platform driver hotplug/coldplug
Message-ID: <20080702085656.GS8489@trinity.fluff.org>
References: <200807020020.22002.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807020020.22002.david-b@pacbell.net>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 12:20:21AM -0700, David Brownell wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
> modalias is prefixed with "platform:". Add MODULE_ALIAS() to the
> hotpluggable parport platform drivers, to re-enable auto loading.
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Ben Dooks <ben-linux@fluff.org>
> ---
>  drivers/parport/parport_ax88796.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/drivers/parport/parport_ax88796.c	2008-07-01 23:58:26.000000000 -0700
> +++ b/drivers/parport/parport_ax88796.c	2008-07-01 23:59:18.000000000 -0700
> @@ -406,6 +406,8 @@ static int parport_ax88796_resume(struct
>  #define parport_ax88796_resume  NULL
>  #endif
>  
> +MODULE_ALIAS("platform:ax88796-pp");
> +
>  static struct platform_driver axdrv = {
>  	.driver		= {
>  		.name	= "ax88796-pp",


-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

