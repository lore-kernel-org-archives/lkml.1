Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbZAGSgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbZAGSgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZAGSgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:36:39 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:39471 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbZAGSgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:36:39 -0500
Date: Wed, 7 Jan 2009 18:36:33 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: i8259.c fix style problems
In-Reply-To: <1231067032.27852.34.camel@jaswinder.satnam>
Message-ID: <alpine.LFD.1.10.0901071814580.11407@ftp.linux-mips.org>
References: <1231067032.27852.34.camel@jaswinder.satnam>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009, Jaswinder Singh Rajput wrote:

> @@ -11,15 +11,15 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/sysdev.h>
>  #include <linux/bitops.h>
> +#include <linux/acpi.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
>  
> -#include <asm/acpi.h>
>  #include <asm/atomic.h>
>  #include <asm/system.h>
> -#include <asm/io.h>
>  #include <asm/timer.h>
>  #include <asm/hw_irq.h>
>  #include <asm/pgtable.h>
> -#include <asm/delay.h>
>  #include <asm/desc.h>
>  #include <asm/apic.h>
>  #include <asm/arch_hooks.h>

 My feeling is this hunk and the following one should be submitted as 
separate patches.

> @@ -323,7 +323,7 @@ void init_8259A(int auto_eoi)
>  	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
>  
>  	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 on x86-64,
> -	                       to 0x20-0x27 on i386 */
> +	   to 0x20-0x27 on i386 */
>  	outb_pic(IRQ0_VECTOR, PIC_MASTER_IMR);
>  
>  	/* 8259A-1 (the master) has a slave on IR2 */

 I think the original formatting is more readable; I would align the two 
'to's vertically even.  You can fix the comment to adhere to the Linux 
coding standard though and the whitespace "problem" will vanish 
automagically.

  Maciej
