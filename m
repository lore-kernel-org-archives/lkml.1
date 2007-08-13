Return-Path: <linux-kernel-owner+w=401wt.eu-S938473AbXHMA66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938473AbXHMA66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 20:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763636AbXHMA6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 20:58:50 -0400
Received: from ozlabs.org ([203.10.76.45]:35207 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764944AbXHMA6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 20:58:49 -0400
Date: Mon, 13 Aug 2007 10:49:03 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: mike zheng <mail4mz@gmail.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: Error: unsupported relocation against CSRR0
Message-ID: <20070813004903.GB15738@localhost.localdomain>
Mail-Followup-To: mike zheng <mail4mz@gmail.com>, linuxppc-dev@ozlabs.org,
	linux-kernel@vger.kernel.org
References: <5c9cd53b0708121404p5e2b8311l5a20ec481a6bed59@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c9cd53b0708121404p5e2b8311l5a20ec481a6bed59@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 05:04:35PM -0400, mike zheng wrote:
> Hi All,
> 
> I have "unsupported relocation against" problem, while compiling entry.S in
> 2.4 Kernel against e500 core.  Does anyone know what is the problem? Is
> there any option I missed?

Probably means you haven't included the file with the #defines for
these SPR values.

> /kernel->   powerpc-linux-gnuspe-gcc -m32 -Wp,-MD,arch/ppc/kernel/.entry.o.d
> -nostdinc -isystem
> /opt/mtwk/usr/local/gcc-3_4-e500-glibc-2.3.4-dp/powerpc-linux-gnuspe/lib/gcc/powerpc-linux-gnuspe/3.4.3/include
> -D__KERNEL__ -Iinclude  -Iarch/ppc -D__ASSEMBLY__ -Iarch/ppc -Wa,-me500    -c
> -o arch/ppc/kernel/entry.o arch/ppc/kernel/entry.S
> arch/ppc/kernel/entry.S: Assembler messages:
> 
> entry.S:819: Error: unsupported relocation against CSRR0
> entry.S:820: Error: unsupported relocation against CSRR1
> entry.S:888: Error: unsupported relocation against MCSRR0
> entry.S:889: Error: unsupported relocation against MCSRR1
> entry.S:909: Error: unsupported relocation against CSRR0
> entry.S:911: Error: unsupported relocation against CSRR1
> 
> 
> 
> entry.S
> 
> 819   mtspr CSRR0, r11
> 820   mtspr CSRR1, r12

> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
