Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbXKTPS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbXKTPS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbXKTPSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:18:48 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:58913 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756708AbXKTPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:18:46 -0500
Message-ID: <4742FACF.7040906@linux.vnet.ibm.com>
Date: Tue, 20 Nov 2007 20:48:39 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45.tar.gz uploaded
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
In-Reply-To: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails, on the AMD machine with following message

arch/x86/ia32/ia32_aout.c: In function ‘load_aout_binary’:
arch/x86/ia32/ia32_aout.c:283: error: implicit declaration of function ‘N_MAGIC’
arch/x86/ia32/ia32_aout.c:283: error: ‘ZMAGIC’ undeclared (first use in this function)
arch/x86/ia32/ia32_aout.c:283: error: (Each undeclared identifier is reported only once
arch/x86/ia32/ia32_aout.c:283: error: for each function it appears in.)
arch/x86/ia32/ia32_aout.c:283: error: ‘OMAGIC’ undeclared (first use in this function)
arch/x86/ia32/ia32_aout.c:284: error: ‘QMAGIC’ undeclared (first use in this function)
arch/x86/ia32/ia32_aout.c:284: error: ‘NMAGIC’ undeclared (first use in this function)
arch/x86/ia32/ia32_aout.c:285: error: implicit declaration of function ‘N_TRSIZE’
arch/x86/ia32/ia32_aout.c:285: error: implicit declaration of function ‘N_DRSIZE’
arch/x86/ia32/ia32_aout.c:287: error: ‘struct exec’ has no member named ‘a_text’
arch/x86/ia32/ia32_aout.c:287: error: ‘struct exec’ has no member named ‘a_data’
arch/x86/ia32/ia32_aout.c:287: error: implicit declaration of function ‘N_SYMSIZE’
arch/x86/ia32/ia32_aout.c:287: error: implicit declaration of function ‘N_TXTOFF’
arch/x86/ia32/ia32_aout.c:300: error: ‘struct exec’ has no member named ‘a_data’
arch/x86/ia32/ia32_aout.c:300: error: ‘struct exec’ has no member named ‘a_bss’
arch/x86/ia32/ia32_aout.c:317: error: ‘struct exec’ has no member named ‘a_text’
arch/x86/ia32/ia32_aout.c:318: error: implicit declaration of function ‘N_TXTADDR’
arch/x86/ia32/ia32_aout.c:319: error: ‘struct exec’ has no member named ‘a_data’
arch/x86/ia32/ia32_aout.c:320: error: implicit declaration of function ‘N_DATADDR’
arch/x86/ia32/ia32_aout.c:321: error: ‘struct exec’ has no member named ‘a_bss’
arch/x86/ia32/ia32_aout.c:322: error: implicit declaration of function ‘N_BSSADDR’
arch/x86/ia32/ia32_aout.c:337: error: ‘struct exec’ has no member named ‘a_text’
arch/x86/ia32/ia32_aout.c:337: error: ‘struct exec’ has no member named ‘a_data’
arch/x86/ia32/ia32_aout.c:350: error: ‘struct exec’ has no member named ‘a_text’
arch/x86/ia32/ia32_aout.c:350: error: ‘struct exec’ has no member named ‘a_data’
arch/x86/ia32/ia32_aout.c:380: error: ‘struct exec’ has no member named ‘a_text’
arch/x86/ia32/ia32_aout.c:380: error: ‘struct exec’ has no member named ‘a_data’
arch/x86/ia32/ia32_aout.c:383: warning: cast to pointer from integer of different size
arch/x86/ia32/ia32_aout.c:384: error: ‘struct exec’ has no member named ‘a_text’
arch/x86/ia32/ia32_aout.c:384: error: ‘struct exec’ has no member named ‘a_data’
arch/x86/ia32/ia32_aout.c:392: error: ‘struct exec’ has no member named ‘a_text’
arch/x86/ia32/ia32_aout.c:405: error: ‘struct exec’ has no member named ‘a_data’
arch/x86/ia32/ia32_aout.c:409: error: ‘struct exec’ has no member named ‘a_text’
arch/x86/ia32/ia32_aout.c:434: error: ‘struct exec’ has no member named ‘a_entry’
arch/x86/ia32/ia32_aout.c: In function ‘load_aout_library’:
arch/x86/ia32/ia32_aout.c:466: error: ‘ZMAGIC’ undeclared (first use in this function)
arch/x86/ia32/ia32_aout.c:466: error: ‘QMAGIC’ undeclared (first use in this function)
arch/x86/ia32/ia32_aout.c:467: error: ‘struct exec’ has no member named ‘a_entry’
arch/x86/ia32/ia32_aout.c:469: error: ‘struct exec’ has no member named ‘a_text’
arch/x86/ia32/ia32_aout.c:469: error: ‘struct exec’ has no member named ‘a_data’
arch/x86/ia32/ia32_aout.c:473: error: implicit declaration of function ‘N_FLAGS’
arch/x86/ia32/ia32_aout.c:479: error: ‘struct exec’ has no member named ‘a_entry’
arch/x86/ia32/ia32_aout.c:495: error: ‘struct exec’ has no member named ‘a_text’
arch/x86/ia32/ia32_aout.c:495: error: ‘struct exec’ has no member named ‘a_data’
arch/x86/ia32/ia32_aout.c:495: error: ‘struct exec’ has no member named ‘a_bss’
arch/x86/ia32/ia32_aout.c:499: error: ‘struct exec’ has no member named ‘a_text’
arch/x86/ia32/ia32_aout.c:499: error: ‘struct exec’ has no member named ‘a_data’
arch/x86/ia32/ia32_aout.c:509: error: ‘struct exec’ has no member named ‘a_text’
arch/x86/ia32/ia32_aout.c:509: error: ‘struct exec’ has no member named ‘a_data’
arch/x86/ia32/ia32_aout.c:518: error: ‘struct exec’ has no member named ‘a_text’
arch/x86/ia32/ia32_aout.c:518: error: ‘struct exec’ has no member named ‘a_data’
arch/x86/ia32/ia32_aout.c:519: error: ‘struct exec’ has no member named ‘a_text’
arch/x86/ia32/ia32_aout.c:519: error: ‘struct exec’ has no member named ‘a_data’
arch/x86/ia32/ia32_aout.c:519: error: ‘struct exec’ has no member named ‘a_bss’
make[1]: *** [arch/x86/ia32/ia32_aout.o] Error 1
make: *** [arch/x86/ia32] Error 2

The patch aout-suppress-aout-library-support-if-config_arch_supports_aout.patch,
creates a struct exec in linux/a.out.h and asm/a.out.h already has it, for the struct
related warnings.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
