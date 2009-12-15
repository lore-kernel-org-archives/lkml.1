Return-Path: <linux-kernel-owner+w=401wt.eu-S1760791AbZLOVO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791AbZLOVO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760492AbZLOVO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:14:57 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:56937 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537AbZLOVO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:14:56 -0500
Date: Tue, 15 Dec 2009 16:14:46 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cs5535: CS5535_MFGPT_DEFAULT_IRQ should depend on 
 CS5535_MFGPT
Message-ID: <20091215161446.0b49ca92@mycelium.queued.net>
In-Reply-To: <alpine.DEB.2.00.0912152201380.4208@ayla.of.borg>
References: <alpine.DEB.2.00.0912152201380.4208@ayla.of.borg>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Andres Salomon <dilinger@collabora.co.uk>

On Tue, 15 Dec 2009
22:02:09 +0100 (CET) Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> From 707c6b36fcf474c31f57a55fa983f3e1db59cf56 Mon Sep 17 00:00:00 2001
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Tue, 15 Dec 2009 21:52:59 +0100
> Subject: [PATCH] cs5535: CS5535_MFGPT_DEFAULT_IRQ should depend on
> CS5535_MFGPT
> 
> It doesn't make much sense to have CS5535_MFGPT_DEFAULT_IRQ show up in
> configs that cannot have CS5535_MFGPT.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/misc/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 59f4ba1..d4beee2 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -203,6 +203,7 @@ config CS5535_MFGPT
>  
>  config CS5535_MFGPT_DEFAULT_IRQ
>  	int
> +	depends on CS5535_MFGPT
>  	default 7
>  	help
>  	  MFGPTs on the CS5535 require an interrupt.  The selected
> IRQ
