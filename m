Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbXJ1RhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbXJ1RhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbXJ1RhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:37:11 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58160 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751570AbXJ1RhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:37:10 -0400
Date: Sun, 28 Oct 2007 18:37:24 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Bradley Smith <bradjsmith@btinternet.com>
Cc: linux-kernel@vger.kernel.org, dz@debian.org
Subject: Re: [PATCH 1/2] I8K: Allow i8k driver to be built on x86_64 systems
Message-ID: <20071028173724.GE7227@stusta.de>
References: <20071028172519.371dbbe8@debian.hob>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071028172519.371dbbe8@debian.hob>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 05:25:19PM +0000, Bradley Smith wrote:
> From: Bradley Smith <bradjsmith@btinternet.com>
> 
> Adds #if clause and additional inline assembly so that the driver
> builds on x86_64 systems.
> 
> Signed-off-by: Bradley Smith <bradjsmith@btinternet.com>
> 
> ---
> 
> --- linux-2.6/drivers/char/i8k.c.orig	2007-10-28 12:27:34.000000000 +0000
> +++ linux-2.6/drivers/char/i8k.c	2007-10-28 14:27:56.000000000 +0000
> @@ -113,6 +113,33 @@ static int i8k_smm(struct smm_regs *regs
>  	int rc;
>  	int eax = regs->eax;
>  
> +#if defined(__x86_64__)
>...

Please use CONFIG_X86_64.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

