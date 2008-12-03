Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbYLCNXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbYLCNXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYLCNXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:23:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44968 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYLCNXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:23:10 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200812031350.46794.rusty@rustcorp.com.au>
References: <200812031350.46794.rusty@rustcorp.com.au> <200812012326.03151.rusty@rustcorp.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
Subject: Re: [RFC 5/8] param: arch_get_boot_command_line() (take II)
Date: Wed, 03 Dec 2008 13:18:57 +0000
Message-ID: <30032.1228310337@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -115,7 +115,6 @@ static struct meminfo meminfo __initdata
>  static struct meminfo meminfo __initdata = { 0, };
>  static const char *cpu_name;
>  static const char *machine_name;
> -static char __initdata command_line[COMMAND_LINE_SIZE];
>  
>  static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
>  static union { char c[4]; unsigned long l; } endian_test __initdata = { { 'l', '?', '?', 'b' 
> } };
> @@ -414,10 +413,12 @@ __early_param("mem=", early_mem);

Your patch is broken here:

	missing header for unified diff at line 140 of patch
	can't find file to patch at input line 140
	Perhaps you used the wrong -p or --strip option?
	The text leading up to this was:
	--------------------------
	|} };
	--------------------------
	File to patch: ^C

Has your email client wrapped a line?

David
