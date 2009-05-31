Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZEaS2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZEaS2c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 14:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZEaS2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 14:28:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbZEaS2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 14:28:23 -0400
Date: Sun, 31 May 2009 20:28:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Trivial Patch Monkey <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix memory map comment
In-Reply-To: <20090530124520.GA8663@localhost>
Message-ID: <alpine.LNX.2.00.0905312028120.11359@wotan.suse.de>
References: <20090530124520.GA8663@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009, Wu Fengguang wrote:

> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
> diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
> index d38c91b..786306c 100644
> --- a/arch/x86/include/asm/page_64_types.h
> +++ b/arch/x86/include/asm/page_64_types.h
> @@ -47,7 +47,7 @@
>  #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
>  #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
>  
> -/* See Documentation/x86_64/mm.txt for a description of the memory map. */
> +/* See Documentation/x86/x86_64/mm.txt for a description of the memory map. */
>  #define __PHYSICAL_MASK_SHIFT	46
>  #define __VIRTUAL_MASK_SHIFT	48

Applied to trivial queue, thanks.

-- 
Jiri Kosina
SUSE Labs
