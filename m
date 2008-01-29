Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbYA2MqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbYA2MqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 07:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbYA2MqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 07:46:08 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:35549 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbYA2MqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 07:46:06 -0500
Message-ID: <479F200C.1020709@s5r6.in-berlin.de>
Date: Tue, 29 Jan 2008 13:46:04 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7]  fix lines over 80 characters
References: <20080129000810.42d0d6f0@paolo-desktop>
In-Reply-To: <20080129000810.42d0d6f0@paolo-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ciarrocchi wrote:
> --- a/arch/x86/math-emu/errors.c
> +++ b/arch/x86/math-emu/errors.c
> @@ -75,7 +75,8 @@ void FPU_printall(void)
>  	  FPU_get_user(FPU_modrm, 1 + (u_char __user *) address);
>  
>  	  if (FPU_modrm >= 0300)
> -	    printk(KERN_ERR " %02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8, FPU_modrm & 7);
> +	    printk(KERN_ERR " %02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8,
> +		FPU_modrm & 7);
>  	  else
>  	    printk(KERN_ERR " /%d, mod=%d rm=%d\n",
>  		   (FPU_modrm >> 3) & 7, (FPU_modrm >> 6) & 3, FPU_modrm & 7);
> @@ -309,7 +310,8 @@ asmlinkage void FPU_exception(int n)
>  	printk(KERN_ERR "FPU emulator: Unknown Exception: 0x%04x!\n", n);
>  
>        if (n == EX_INTERNAL) {
> -	  printk(KERN_ERR "FPU emulator: Internal error type 0x%04x\n", int_type);
> +	  printk(KERN_ERR "FPU emulator: Internal error type 0x%04x\n",
> +		int_type);
>  	  FPU_printall();
>  	}
>  #ifdef PRINT_MESSAGES


The "fix" is still not conforming to CodingStyle.

Besides, why don't you leave these lines as they are?  There is no
important information hidden behind the 80th column in the existing code.
-- 
Stefan Richter
-=====-==--- ---= ===-=
http://arcgraph.de/sr/
