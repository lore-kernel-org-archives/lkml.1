Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbYBRDNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbYBRDNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 22:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYBRDNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 22:13:05 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1788 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756806AbYBRDNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 22:13:04 -0500
Subject: Re: [PATCH] x86: Coding style fixes for
	arch/x86/kernel/cpu/centaur.c
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080218025645.GB30201@elte.hu>
References: <20080217233023.26764dc9@paolo-desktop>
	 <20080218025645.GB30201@elte.hu>
Content-Type: text/plain
Date: Sun, 17 Feb 2008 19:12:24 -0800
Message-Id: <1203304344.7181.45.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-18 at 03:56 +0100, Ingo Molnar wrote:
>  arch/x86/kernel/cpu/centaur.c |  394 +++++++++++++++++++++---------------------
>  1 file changed, 199 insertions(+), 195 deletions(-)
> 
> Index: linux-x86.q/arch/x86/kernel/cpu/centaur.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/cpu/centaur.c
> +++ linux-x86.q/arch/x86/kernel/cpu/centaur.c
> @@ -52,13 +54,12 @@ static u32 __cpuinit ramtop(void)		/* 16
>  		if (e820.map[i].addr > 0xFFFFFFFFUL)
>  			continue;
>  		/*
> -		 *	Don't MCR over reserved space. Ignore the ISA hole
> -		 *	we frob around that catastrophe already
> +		 * Don't MCR over reserved space. Ignore the ISA hole
> +		 * we frob around that catastrophe already
>  		 */
> -
> -		if (e820.map[i].type == E820_RESERVED)
> -		{
> -			if (e820.map[i].addr >= 0x100000UL && e820.map[i].addr < clip)
> +		if (e820.map[i].type == E820_RESERVED) {
> +			if (e820.map[i].addr >= 0x100000UL &&
> +						e820.map[i].addr < clip)
>  				clip = e820.map[i].addr;

Doesn't this look better as:

+			if (e820.map[i].addr >= 0x100000UL &&
+			    e820.map[i].addr < clip)


