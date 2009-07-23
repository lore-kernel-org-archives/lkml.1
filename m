Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbZGWAjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbZGWAjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 20:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZGWAjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 20:39:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751815AbZGWAjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 20:39:01 -0400
Date: Wed, 22 Jul 2009 17:38:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <mike@compulab.co.il>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, denis@compulab.co.il,
       mike@compulab.co.il
Subject: Re: [PATCH] Add reboot fixup for SBC-fitPC2
Message-Id: <20090722173854.fdbcee7f.akpm@linux-foundation.org>
In-Reply-To: <4A6491C1.5060909@compulab.co.il>
References: <4A6491C1.5060909@compulab.co.il>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009 18:48:17 +0300
Mike Rapoport <mike@compulab.co.il> wrote:

> > From: Denis Turischev <denis@compulab.co.il>
> 
> This patch adds reboot fixup for CompuLab SBC-fitPC2 board.
> 
> Singned-off-by: Denis Turischev <denis@compulab.co.il>
> Signedd-off-by: Mike Rapoport <mike@compulab.co.il
> 
> diff -Nru linux-2.6.31-rc3.orig/arch/x86/kernel/reboot.c
> linux-2.6.31-rc3/arch/x86/kernel/reboot.c
> --- linux-2.6.31-rc3.orig/arch/x86/kernel/reboot.c	2009-07-14 04:18:52.000000000
> +0300
> +++ linux-2.6.31-rc3/arch/x86/kernel/reboot.c	2009-07-16 14:39:48.000000000 +0300
> @@ -249,6 +249,15 @@
>  			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
>  		},
>  	},
> +	{	/* Handle problems with rebooting on
> +				CompuLab SBC-FITPC2 board */
> +		.callback = set_bios_reboot,
> +		.ident = "CompuLab SBC-FITPC2",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "CompuLab"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
> +		},
> +	},
>  	{ }
>  };
> 

Neither this patch nor Denis's earlier version contained an adequate
decription.  We aren't told what these "problems" are, so we're unable
to judge the appropriateness of patch.

Both patches were wordwrapped.

Both patches use an atypical layout style for the comments.

I fixed up some of these things and merged the patch into my tree, for
sending to Ingo for 2.6.32.

Please send a description of the problem which the patch fixes and I
shall add that to my copy of the changelog.

Thanks.
