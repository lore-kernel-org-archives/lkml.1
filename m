Return-Path: <linux-kernel-owner+w=401wt.eu-S1761269AbZENHzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269AbZENHzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 03:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759528AbZENHy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 03:54:57 -0400
Received: from www.tglx.de ([62.245.132.106]:49507 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756857AbZENHy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 03:54:56 -0400
Date: Thu, 14 May 2009 09:53:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: apic/apic.c declare default_init_apic_ldr()
 before it get used
In-Reply-To: <1242251841.3364.17.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0905140952220.3561@localhost.localdomain>
References: <1242251841.3364.17.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Jaswinder Singh Rajput wrote:
> 
> default_init_apic_ldr() is also required for 64 bit so moving it out
> from CONFIG_X86_32.

[linux-2.6-tip]$ git grep default_init_apic_ldr arch/x86/
arch/x86/include/asm/apic.h:extern void default_init_apic_ldr(void);
arch/x86/kernel/apic/apic.c:void default_init_apic_ldr(void)
arch/x86/kernel/apic/probe_32.c:        .init_apic_ldr                  = default_init_apic_ldr,

I have a hard time to see how 64bit requires that function.

Thanks,

	tglx
