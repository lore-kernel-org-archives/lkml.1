Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYECVHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYECVHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbYECVHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:07:39 -0400
Received: from www.tglx.de ([62.245.132.106]:48348 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbYECVHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:07:38 -0400
Date: Sat, 3 May 2008 23:07:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
       ralf@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] x86: relocs ELF handling - use SELFMAG instead of
 numeric constant
In-Reply-To: <481c3f59.0407560a.2cbe.ffffd575@mx.google.com>
Message-ID: <alpine.LFD.1.10.0805032306530.6003@apollo.tec.linutronix.de>
References: <20080503101800.417039810@gmail.com>> <481c3f59.0407560a.2cbe.ffffd575@mx.google.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008, Cyrill Gorcunov wrote:
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> Index: linux-2.6.git/arch/x86/boot/compressed/relocs.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/boot/compressed/relocs.c	2008-04-29 21:20:57.000000000 +0400
> +++ linux-2.6.git/arch/x86/boot/compressed/relocs.c	2008-05-02 21:38:41.000000000 +0400
> @@ -191,7 +191,7 @@ static void read_ehdr(FILE *fp)
>  		die("Cannot read ELF header: %s\n",
>  			strerror(errno));
>  	}
> -	if (memcmp(ehdr.e_ident, ELFMAG, 4) != 0) {
> +	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0) {
>  		die("No ELF magic\n");
>  	}
>  	if (ehdr.e_ident[EI_CLASS] != ELFCLASS32) {

Applied. Thanks,

	 tglx
