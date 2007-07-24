Return-Path: <linux-kernel-owner+w=401wt.eu-S934186AbXGXBSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186AbXGXBSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 21:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759535AbXGXBSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 21:18:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51817 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759311AbXGXBSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 21:18:43 -0400
Message-ID: <46A5536E.6010606@garzik.org>
Date: Mon, 23 Jul 2007 21:18:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc1: i386 section mismatch warnings
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

make allmodconfig on i386:

WARNING: vmlinux(.text+0xc0101183): Section mismatch: reference to 
.init.text:start_kernel (between 'is386' and 'check_x87')
WARNING: vmlinux(.text+0xc02cfcdb): Section mismatch: reference to 
.init.text:kernel_init (between 'rest_init' and 'kthreadd_setup')
WARNING: vmlinux(.text+0xc02d5ed2): Section mismatch: reference to 
.init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02d5ede): Section mismatch: reference to 
.init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02d5eea): Section mismatch: reference to 
.init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02d5ef6): Section mismatch: reference to 
.init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02cfda4): Section mismatch: reference to 
.init.text:__alloc_bootmem_node (between 'alloc_node_mem_map' and 
'zone_wait_table_init')
WARNING: vmlinux(.text+0xc02cfe4e): Section mismatch: reference to 
.init.text:__alloc_bootmem_node (between 'zone_wait_table_init' and 
'vgacon_scrollback_startup')
WARNING: vmlinux(.text+0xc02d64c6): Section mismatch: reference to 
.init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02cfea7): Section mismatch: reference to 
.init.text:__alloc_bootmem (between 'vgacon_scrollback_startup' and 
'fb_find_logo')
WARNING: vmlinux(.text+0xc02cfecb): Section mismatch: reference to 
.init.data:logo_linux_mono (between 'fb_find_logo' and 'schedule')
WARNING: vmlinux(.text+0xc02cfed5): Section mismatch: reference to 
.init.data:logo_linux_clut224 (between 'fb_find_logo' and 'schedule')
WARNING: vmlinux(.text+0xc02cfeda): Section mismatch: reference to 
.init.data:logo_linux_vga16 (between 'fb_find_logo' and 'schedule')
WARNING: vmlinux(.text+0xc02d6612): Section mismatch: reference to 
.init.text: (between 'iret_exc' and '_etext')
