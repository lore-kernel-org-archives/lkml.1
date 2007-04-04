Return-Path: <linux-kernel-owner+w=401wt.eu-S1750833AbXDDUhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750833AbXDDUhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbXDDUhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:37:53 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:30606 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbXDDUhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:37:51 -0400
Date: Wed, 4 Apr 2007 13:39:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, Jarkko Lavinen <jarkko.lavinen@nokia.com>
Subject: Re: [PATCH 73/90] ARM: OMAP: Add onennand board specific support
 for N800
Message-Id: <20070404133909.1a699f6a.randy.dunlap@oracle.com>
In-Reply-To: <11757101683521-git-send-email-tony@atomide.com>
References: <11757099691323-git-send-email-tony@atomide.com>
	<11757100713004-git-send-email-tony@atomide.com>
	<11757100752021-git-send-email-tony@atomide.com>
	<11757100781275-git-send-email-tony@atomide.com>
	<11757100811771-git-send-email-tony@atomide.com>
	<11757100821353-git-send-email-tony@atomide.com>
	<11757100853841-git-send-email-tony@atomide.com>
	<1175710087578-git-send-email-tony@atomide.com>
	<11757100911247-git-send-email-tony@atomide.com>
	<1175710093864-git-send-email-tony@atomide.com>
	<11757100952384-git-send-email-tony@atomide.com>
	<11757100982726-g!
 it-send-email-tony@atomide.com>
	<11757101012787-git-send-email-tony@atomide.com>
	<1175710103340-git-send-email-tony@atomide.com>
	<11757101072553-git-send-email-tony@atomide.com>
	<11757101101180-git-send-email-tony@atomide.com>
	<11757101123620-git-send-email-tony@atomide.com>
	<11757101141643-git-send-email-tony@atomide.com>
	<11757101683521-git-send-email-tony@atomide.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2007 14:05:52 -0400 Tony Lindgren wrote:

> From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
> 
> Add onennand board specific support for N800
> 
> Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap2/board-n800-flash.c |   97 +++++++++++++++++++++++++++++++-
>  include/asm-arm/arch-omap/onenand.h    |    1 +
>  2 files changed, 97 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-n800-flash.c b/arch/arm/mach-omap2/board-n800-flash.c
> index cd302ab..4005cfb 100644
> --- a/arch/arm/mach-omap2/board-n800-flash.c
> +++ b/arch/arm/mach-omap2/board-n800-flash.c

>  static struct omap_onenand_platform_data n800_onenand_data = {
>  	.cs = 0,
>  	.gpio_irq = 26,
>  	.parts = n800_partitions,
> -	.nr_parts = 0 /* filled later */
> +	.nr_parts = 0, /* filled later */
> +	.onenand_setup = n800_onenand_setup
>  };

FYI, it's common practice to put a comma at the end of the last
item, like

> +	.onenand_setup = n800_onenand_setup,

That won't generate a syntax error (with gcc) and it allows someone
to add lines after it without touching that line (e.g., like the
nr_parts line here).


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
