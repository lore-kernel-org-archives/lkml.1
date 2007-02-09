Return-Path: <linux-kernel-owner+w=401wt.eu-S1946671AbXBIQrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946671AbXBIQrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946667AbXBIQrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:47:21 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:44924 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946638AbXBIQrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:47:06 -0500
Message-ID: <45CCA58C.90604@gmail.com>
Date: Fri, 09 Feb 2007 17:47:08 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, rth@twiddle.net
Subject: Re: [PATCH 01/34] __initdata cleanup - alpha
References: <200702091711.34441.alon.barlev@gmail.com> <200702091713.23091.alon.barlev@gmail.com>
In-Reply-To: <200702091713.23091.alon.barlev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alon Bar-Lev napsal(a):
> Trivial.
> 
> Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> 
> ---
> 
> diff -urNp linux-2.6.20-rc6-mm3.org/arch/alpha/kernel/setup.c linux-2.6.20-rc6-mm3/arch/alpha/kernel/setup.c
> --- linux-2.6.20-rc6-mm3.org/arch/alpha/kernel/setup.c	2007-01-31 22:15:30.000000000 +0200
> +++ linux-2.6.20-rc6-mm3/arch/alpha/kernel/setup.c	2007-01-31 22:19:30.000000000 +0200
> @@ -122,7 +122,7 @@ static void get_sysnames(unsigned long, 
>  			 char **, char **);
>  static void determine_cpu_caches (unsigned int);
>  
> -static char __initdata command_line[COMMAND_LINE_SIZE];
> +static char __initdata command_line[COMMAND_LINE_SIZE] = "";

Why is this "= 0" to static global variables needed?

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
