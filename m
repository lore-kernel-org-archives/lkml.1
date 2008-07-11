Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYGKTVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYGKTVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbYGKTSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:18:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759485AbYGKTSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:18:50 -0400
Date: Fri, 11 Jul 2008 12:18:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 04/04] resource: add new IORESOURCE_CLK type
Message-Id: <20080711121813.acc71327.akpm@linux-foundation.org>
In-Reply-To: <20080709115502.14144.49264.sendpatchset@rx1.opensource.se>
References: <20080709115428.14144.7121.sendpatchset@rx1.opensource.se>
	<20080709115502.14144.49264.sendpatchset@rx1.opensource.se>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 20:55:02 +0900 Magnus Damm <magnus.damm@gmail.com> wrote:

> This patch rearranges the values of the IORESOURCE_TYPE_BITS from
> one bit per type to a 4-bit counter. Also, IORESOURCE_CLK is added.
> Not sure if it is better to start counting from 0 instead of 1.
> 

I don't believe this is an adequate changelog.  It contains the "what" but
not the "why".

Why did we switch from one-bit to four-bits?

Why did we add IORESOURCE_CLK?

The latter was convered in [0/n] a bit, but not at all clearly/fully.


> ---
> 
>  include/linux/ioport.h |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- 0003/include/linux/ioport.h
> +++ work/include/linux/ioport.h	2008-07-09 15:19:45.000000000 +0900
> @@ -37,8 +37,9 @@ struct resource_list {
>  #define IORESOURCE_TYPE_BITS	0x00000f00	/* Resource type */
>  #define IORESOURCE_IO		0x00000100
>  #define IORESOURCE_MEM		0x00000200
> -#define IORESOURCE_IRQ		0x00000400
> -#define IORESOURCE_DMA		0x00000800
> +#define IORESOURCE_IRQ		0x00000300
> +#define IORESOURCE_DMA		0x00000400
> +#define IORESOURCE_CLK		0x00000500
>  
>  #define IORESOURCE_PREFETCH	0x00001000	/* No side effects */
>  #define IORESOURCE_READONLY	0x00002000
