Return-Path: <linux-kernel-owner+w=401wt.eu-S1030965AbXDPVEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030965AbXDPVEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030966AbXDPVEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:04:47 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3744 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030965AbXDPVEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:04:46 -0400
Date: Mon, 16 Apr 2007 22:04:29 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       Tim Yamin <plasmaroo@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH UPDATE] deflate stack usage in lib/inflate.c
Message-ID: <20070416210429.GD19713@flint.arm.linux.org.uk>
Mail-Followup-To: Jeremy Fitzhardinge <jeremy@goop.org>,
	Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tim Yamin <plasmaroo@gentoo.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@suse.de>
References: <461DED14.1070603@goop.org> <461E9BAD.8050202@goop.org> <20070412222547.GA11166@waste.org> <461EB96C.5060603@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461EB96C.5060603@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 03:57:48PM -0700, Jeremy Fitzhardinge wrote:
> diff -r 2ad8a0729f26 arch/arm/boot/compressed/misc.c
> --- a/arch/arm/boot/compressed/misc.c	Thu Apr 12 13:44:02 2007 -0700
> +++ b/arch/arm/boot/compressed/misc.c	Thu Apr 12 15:48:43 2007 -0700
> @@ -239,7 +239,7 @@ static ulg free_mem_ptr;
>  static ulg free_mem_ptr;
>  static ulg free_mem_ptr_end;
>  
> -#define HEAP_SIZE 0x2000
> +#define HEAP_SIZE 0x3000

Not used on ARM, this macro can be deleted.  For the record, the space
available to the decompressor on ARM is 64K.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
