Return-Path: <linux-kernel-owner+w=401wt.eu-S1764037AbXKTUv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764037AbXKTUv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761684AbXKTUvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:51:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59860 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761739AbXKTUvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:51:39 -0500
Date: Tue, 20 Nov 2007 12:50:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com, apw@shadowen.org,
       balbir@linux.vnet.ibm.com
Subject: Re: mm snapshot broken-out-2007-11-20-01-45.tar.gz uploaded
Message-Id: <20071120125029.dfd58d83.akpm@linux-foundation.org>
In-Reply-To: <4742FACF.7040906@linux.vnet.ibm.com>
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
	<4742FACF.7040906@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 20:48:39 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> The kernel build fails, on the AMD machine with following message
> 
> arch/x86/ia32/ia32_aout.c: In function ___load_aout_binary___:
> arch/x86/ia32/ia32_aout.c:283: error: implicit declaration of function ___N_MAGIC___
> arch/x86/ia32/ia32_aout.c:283: error: ___ZMAGIC___ undeclared (first use in this function)
> arch/x86/ia32/ia32_aout.c:283: error: (Each undeclared identifier is reported only once
> arch/x86/ia32/ia32_aout.c:283: error: for each function it appears in.)
> arch/x86/ia32/ia32_aout.c:283: error: ___OMAGIC___ undeclared (first use in this function)
> arch/x86/ia32/ia32_aout.c:284: error: ___QMAGIC___ undeclared (first use in this function)
> arch/x86/ia32/ia32_aout.c:284: error: ___NMAGIC___ undeclared (first use in this function)
> arch/x86/ia32/ia32_aout.c:285: error: implicit declaration of function ___N_TRSIZE___
> arch/x86/ia32/ia32_aout.c:285: error: implicit declaration of function ___N_DRSIZE___
> arch/x86/ia32/ia32_aout.c:287: error: ___struct exec___ has no member named ___a_text___
> arch/x86/ia32/ia32_aout.c:287: error: ___struct exec___ has no member named ___a_data___
> arch/x86/ia32/ia32_aout.c:287: error: implicit declaration of function ___N_SYMSIZE___
> arch/x86/ia32/ia32_aout.c:287: error: implicit declaration of function ___N_TXTOFF___
> arch/x86/ia32/ia32_aout.c:300: error: ___struct exec___ has no member named ___a_data___
> arch/x86/ia32/ia32_aout.c:300: error: ___struct exec___ has no member named ___a_bss___
> arch/x86/ia32/ia32_aout.c:317: error: ___struct exec___ has no member named ___a_text___
> arch/x86/ia32/ia32_aout.c:318: error: implicit declaration of function ___N_TXTADDR___
> arch/x86/ia32/ia32_aout.c:319: error: ___struct exec___ has no member named ___a_data___
> arch/x86/ia32/ia32_aout.c:320: error: implicit declaration of function ___N_DATADDR___
> arch/x86/ia32/ia32_aout.c:321: error: ___struct exec___ has no member named ___a_bss___
> arch/x86/ia32/ia32_aout.c:322: error: implicit declaration of function ___N_BSSADDR___
> arch/x86/ia32/ia32_aout.c:337: error: ___struct exec___ has no member named ___a_text___
> arch/x86/ia32/ia32_aout.c:337: error: ___struct exec___ has no member named ___a_data___
> arch/x86/ia32/ia32_aout.c:350: error: ___struct exec___ has no member named ___a_text___
> arch/x86/ia32/ia32_aout.c:350: error: ___struct exec___ has no member named ___a_data___
> arch/x86/ia32/ia32_aout.c:380: error: ___struct exec___ has no member named ___a_text___
> arch/x86/ia32/ia32_aout.c:380: error: ___struct exec___ has no member named ___a_data___
> arch/x86/ia32/ia32_aout.c:383: warning: cast to pointer from integer of different size
> arch/x86/ia32/ia32_aout.c:384: error: ___struct exec___ has no member named ___a_text___
> arch/x86/ia32/ia32_aout.c:384: error: ___struct exec___ has no member named ___a_data___
> arch/x86/ia32/ia32_aout.c:392: error: ___struct exec___ has no member named ___a_text___
> arch/x86/ia32/ia32_aout.c:405: error: ___struct exec___ has no member named ___a_data___
> arch/x86/ia32/ia32_aout.c:409: error: ___struct exec___ has no member named ___a_text___
> arch/x86/ia32/ia32_aout.c:434: error: ___struct exec___ has no member named ___a_entry___
> arch/x86/ia32/ia32_aout.c: In function ___load_aout_library___:
> arch/x86/ia32/ia32_aout.c:466: error: ___ZMAGIC___ undeclared (first use in this function)
> arch/x86/ia32/ia32_aout.c:466: error: ___QMAGIC___ undeclared (first use in this function)
> arch/x86/ia32/ia32_aout.c:467: error: ___struct exec___ has no member named ___a_entry___
> arch/x86/ia32/ia32_aout.c:469: error: ___struct exec___ has no member named ___a_text___
> arch/x86/ia32/ia32_aout.c:469: error: ___struct exec___ has no member named ___a_data___
> arch/x86/ia32/ia32_aout.c:473: error: implicit declaration of function ___N_FLAGS___
> arch/x86/ia32/ia32_aout.c:479: error: ___struct exec___ has no member named ___a_entry___
> arch/x86/ia32/ia32_aout.c:495: error: ___struct exec___ has no member named ___a_text___
> arch/x86/ia32/ia32_aout.c:495: error: ___struct exec___ has no member named ___a_data___
> arch/x86/ia32/ia32_aout.c:495: error: ___struct exec___ has no member named ___a_bss___
> arch/x86/ia32/ia32_aout.c:499: error: ___struct exec___ has no member named ___a_text___
> arch/x86/ia32/ia32_aout.c:499: error: ___struct exec___ has no member named ___a_data___
> arch/x86/ia32/ia32_aout.c:509: error: ___struct exec___ has no member named ___a_text___
> arch/x86/ia32/ia32_aout.c:509: error: ___struct exec___ has no member named ___a_data___
> arch/x86/ia32/ia32_aout.c:518: error: ___struct exec___ has no member named ___a_text___
> arch/x86/ia32/ia32_aout.c:518: error: ___struct exec___ has no member named ___a_data___
> arch/x86/ia32/ia32_aout.c:519: error: ___struct exec___ has no member named ___a_text___
> arch/x86/ia32/ia32_aout.c:519: error: ___struct exec___ has no member named ___a_data___
> arch/x86/ia32/ia32_aout.c:519: error: ___struct exec___ has no member named ___a_bss___
> make[1]: *** [arch/x86/ia32/ia32_aout.o] Error 1
> make: *** [arch/x86/ia32] Error 2
> 
> The patch aout-suppress-aout-library-support-if-config_arch_supports_aout.patch,
> creates a struct exec in linux/a.out.h and asm/a.out.h already has it, for the struct
> related warnings.
> 

OK, I've had it with trying to get that patch to vaguely work.  I'll drop
it and will then fix up the extensive dependency trail which it drags along
behind it.

David, please do not bring it back until it has had a *lot* of testing.

