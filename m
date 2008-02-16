Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbYBPSLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbYBPSLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 13:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYBPSLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 13:11:24 -0500
Received: from www.tglx.de ([62.245.132.106]:43560 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759199AbYBPSLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 13:11:23 -0500
Date: Sat, 16 Feb 2008 19:11:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: sparse error in efi_32.c
In-Reply-To: <1202937999.18204.7.camel@brick>
Message-ID: <alpine.LFD.1.00.0802161910460.7583@apollo.tec.linutronix.de>
References: <1202937999.18204.7.camel@brick>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Harvey Harrison wrote:

> include/linux/efi.h does not include asm/efi.h, efi.c and efi_64.c
> explicitly include both.  While not really right, add the include
> to efi_32.c until the header gets sorted out.
> 
> arch/x86/kernel/efi_32.c:42:6: warning: symbol 'efi_call_phys_prelog' was not declared. Should it be static?
> arch/x86/kernel/efi_32.c:84:6: warning: symbol 'efi_call_phys_epilog' was not declared. Should it be static?
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Applied. Thanks

	 tglx
