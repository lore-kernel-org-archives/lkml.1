Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbXEaBCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbXEaBCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 21:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbXEaBC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 21:02:29 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbXEaBC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 21:02:28 -0400
Date: Wed, 30 May 2007 18:02:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: section mismatches
Message-Id: <20070530180217.bebfa4b0.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Mostly from Andi's tree:

WARNING: arch/i386/kernel/head.o(.note.Xen+0x68): Section mismatch: reference to .init.text:startup_xen
WARNING: vmlinux(.text+0xc0101183): Section mismatch: reference to .init.text:start_kernel (between 'is386' and 'check_x87')
WARNING: vmlinux(.text+0xc02fc63b): Section mismatch: reference to .init.text:kernel_init (between 'rest_init' and 'alloc_node_mem_map')
WARNING: vmlinux(.text+0xc0302e16): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc0302e22): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc0302e2e): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc0302e3a): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02fc6c7): Section mismatch: reference to .init.text:__alloc_bootmem_node (between 'alloc_node_mem_map' and 'zone_wait_table_init')
WARNING: vmlinux(.text+0xc02fc797): Section mismatch: reference to .init.text:__alloc_bootmem_node (between 'zone_wait_table_init' and 'schedule')
WARNING: vmlinux(.text+0xc0222408): Section mismatch: reference to .init.text:__alloc_bootmem (between 'vgacon_startup' and 'vgacon_scrolldelta')
WARNING: vmlinux(.text+0xc03034c1): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc030360d): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.notes+0x3d28): Section mismatch: reference to .init.text:startup_xen
