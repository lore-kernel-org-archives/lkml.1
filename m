Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZIAPvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZIAPvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 11:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZIAPvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 11:51:23 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:55802 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbZIAPvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 11:51:22 -0400
Date: Tue, 1 Sep 2009 17:51:10 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Stoyan Gaydarov <sgayda2@uiuc.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 7/7] [cris] ARRAY_SIZE changes
Message-ID: <20090901155110.GS18552@axis.com>
References: <1248231753-8344-1-git-send-email-sgayda2@uiuc.edu> <1248231753-8344-2-git-send-email-sgayda2@uiuc.edu> <1248231753-8344-3-git-send-email-sgayda2@uiuc.edu> <1248231753-8344-4-git-send-email-sgayda2@uiuc.edu> <1248231753-8344-5-git-send-email-sgayda2@uiuc.edu> <1248231753-8344-6-git-send-email-sgayda2@uiuc.edu> <1248231753-8344-7-git-send-email-sgayda2@uiuc.edu> <1248231753-8344-8-git-send-email-sgayda2@uiuc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248231753-8344-8-git-send-email-sgayda2@uiuc.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 05:02:33AM +0200, Stoyan Gaydarov wrote:
> These changes were a direct result of using a semantic patch
> More information can be found at http://www.emn.fr/x-info/coccinelle/

Thanks, added to the cris-tree.

> Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
> ---
>  arch/cris/arch-v32/mach-a3/io.c |    2 +-
>  arch/cris/arch-v32/mach-fs/io.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/cris/arch-v32/mach-a3/io.c b/arch/cris/arch-v32/mach-a3/io.c
> index c22f67e..090ceb9 100644
> --- a/arch/cris/arch-v32/mach-a3/io.c
> +++ b/arch/cris/arch-v32/mach-a3/io.c
> @@ -36,7 +36,7 @@ struct crisv32_ioport crisv32_ioports[] = {
>  	},
>  };
>  
> -#define NBR_OF_PORTS sizeof(crisv32_ioports)/sizeof(struct crisv32_ioport)
> +#define NBR_OF_PORTS ARRAY_SIZE(crisv32_ioports)
>  
>  struct crisv32_iopin crisv32_led_net0_green;
>  struct crisv32_iopin crisv32_led_net0_red;
> diff --git a/arch/cris/arch-v32/mach-fs/io.c b/arch/cris/arch-v32/mach-fs/io.c
> index cb6327b..a695866 100644
> --- a/arch/cris/arch-v32/mach-fs/io.c
> +++ b/arch/cris/arch-v32/mach-fs/io.c
> @@ -52,7 +52,7 @@ struct crisv32_ioport crisv32_ioports[] = {
>  	}
>  };
>  
> -#define NBR_OF_PORTS sizeof(crisv32_ioports)/sizeof(struct crisv32_ioport)
> +#define NBR_OF_PORTS ARRAY_SIZE(crisv32_ioports)
>  
>  struct crisv32_iopin crisv32_led_net0_green;
>  struct crisv32_iopin crisv32_led_net0_red;
> -- 
> 1.6.3.3
/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
