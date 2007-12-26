Return-Path: <linux-kernel-owner+w=401wt.eu-S1751810AbXLZM0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbXLZM0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 07:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbXLZMZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 07:25:59 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2279 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbXLZMZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 07:25:58 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: 2.6.24-rc6-mm1: some section mismatches on sparc64
Date: Wed, 26 Dec 2007 13:29:07 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
References: <20071222233056.d652743e.akpm@linux-foundation.org>
In-Reply-To: <20071222233056.d652743e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200712261329.08313.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

WARNING: vmlinux.o(.text+0x46b04): Section mismatch: reference to .init.text:sun4v_ktsb_register (between 'smp_callin' and 'smp_fill_in_sib_core_maps')
WARNING: vmlinux.o(.text+0x4756c): Section mismatch: reference to .init.text:sun4v_register_mondo_queues (between 'after_lock_tlb' and 'hv_cpu_startup')
WARNING: vmlinux.o(.text+0x477ac): Section mismatch: reference to .init.text:sun4v_register_mondo_queues (between 'hv_cpu_startup' and 'sys32_exit')
WARNING: vmlinux.o(.text+0x55258): Section mismatch: reference to .init.text:__alloc_bootmem (between 'kernel_map_range' and 'kernel_map_pages')
WARNING: vmlinux.o(.text+0x55278): Section mismatch: reference to .init.text:__alloc_bootmem (between 'kernel_map_range' and 'kernel_map_pages')
WARNING: vmlinux.o(.text+0x1fdfe4): Section mismatch: reference to .init.text:sunserial_console_match (between 'hv_probe' and 'serial_in')
WARNING: vmlinux.o(.text+0x20011c): Section mismatch: reference to .init.text:sunserial_console_match (between 'su_probe' and 'sunsu_console_putchar')
WARNING: vmlinux.o(.sun4v_2insn_patch+0x3d8): Section mismatch: reference to .init.text:
WARNING: vmlinux.o(__ksymtab+0x62c0): Section mismatch: reference to .init.text:sunserial_console_match (between '__ksymtab_sunserial_console_match' and '__ksymtab_sunserial_unregister_minors')

Regards,

	Mariusz
