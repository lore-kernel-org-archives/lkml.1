Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbYCZMct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbYCZMct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 08:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbYCZMci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 08:32:38 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:44143 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbYCZMcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 08:32:36 -0400
Date: Wed, 26 Mar 2008 13:32:27 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bryan Wu <cooloney@kernel.org>
cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] Blackfin Video Driver: Update
 the BF52x EZKIT video framebuffer driver according to LKML review
In-Reply-To: <1206580775-23929-2-git-send-email-cooloney@kernel.org>
Message-ID: <Pine.LNX.4.64.0803261331260.13478@anakin>
References: <> <1206580775-23929-2-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Bryan Wu wrote:
> @@ -552,11 +544,11 @@ static int __init bfin_t350mcqb_probe(struct platform_device *pdev)
>  		goto out7;
>  	}
>  
> -	if (request_irq(info->irq, (void *)bfin_t350mcqb_irq_error, IRQF_DISABLED,
> -			"PPI ERROR", info) < 0) {
> +	ret = request_irq(info->irq, (void *)bfin_t350mcqb_irq_error, IRQF_DISABLED,
                                     ^^^^^^^^
This cast should not be necessary. If it is, the signature of
bfin_t350mcqb_irq_error() is incorrect.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
