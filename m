Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbYCMU7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbYCMU7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYCMU7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:59:45 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:43725 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753083AbYCMU7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:59:44 -0400
Date: Thu, 13 Mar 2008 21:59:51 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: nicolas.ferre@atmel.com
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Sedji GAOUAOU <sedji.gaouaou@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: [Linux-fbdev-devel] [PATCH] atmel_lcdfb: adjust fifo size for
 at91sam9rl
Message-ID: <20080313215951.3375a453@siona.local>
In-Reply-To: <47D5639A.3090609@atmel.com>
References: <47D5639A.3090609@atmel.com>
Organization: Atmel
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2008 20:59:11.0046 (UTC) FILETIME=[16237E60:01C8854D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 17:36:42 +0100
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> -#if defined(CONFIG_ARCH_AT91SAM9263)
> +#if defined(CONFIG_ARCH_AT91SAM9263) || defined(CONFIG_ARCH_AT91SAM9RL)
>  #define ATMEL_LCDC_FIFO_SIZE		2048
>  #else
>  #define ATMEL_LCDC_FIFO_SIZE		512

Hmm. Perhaps it's time to consider moving this parameter to
platform_data?

Haavard
