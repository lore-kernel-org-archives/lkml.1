Return-Path: <linux-kernel-owner+w=401wt.eu-S939840AbXGTBro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939840AbXGTBro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761904AbXGTBrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:47:37 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:55072 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761080AbXGTBrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:47:37 -0400
Message-ID: <46A013DA.1080602@googlemail.com>
Date: Fri, 20 Jul 2007 03:46:02 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Some 'Section mismatch' warnings on current git head with allmodconfig
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this warnings with allmodconfig on
64fb98fc40738ae1a98bcea9ca3145b89fb71524


...

  MODPOST 2126 modules
  CC      arch/i386/boot/tty.o
  CC      arch/i386/boot/video.o
WARNING: vmlinux(.text+0xc0101183): Section mismatch: reference to
.init.text:start_kernel (between 'is386' and 'check_x87')
WARNING: vmlinux(.text+0xc02da787): Section mismatch: reference to
.init.text:kernel_init (between 'rest_init' and 'kthreadd_setup')
WARNING: vmlinux(.text+0xc02e0797): Section mismatch: reference to
.init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02e07a3): Section mismatch: reference to
.init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02e07af): Section mismatch: reference to
.init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02e07bb): Section mismatch: reference to
.init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02da850): Section mismatch: reference to
.init.text:__alloc_bootmem_node (between 'alloc_node_mem_map' and
'zone_wait_table_init')
WARNING: vmlinux(.text+0xc02da8f9): Section mismatch: reference to
.init.text:__alloc_bootmem_node (between 'zone_wait_table_init' and
'fb_find_logo')
WARNING: vmlinux(.text+0xc02083a5): Section mismatch: reference to
.init.text:__alloc_bootmem (between 'vgacon_startup' and
'vgacon_scrolldelta')
WARNING: vmlinux(.text+0xc02e0d8b): Section mismatch: reference to
.init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02da947): Section mismatch: reference to
.init.data:logo_linux_mono (between 'fb_find_logo' and 'schedule')
WARNING: vmlinux(.text+0xc02da951): Section mismatch: reference to
.init.data:logo_linux_clut224 (between 'fb_find_logo' and 'schedule')
WARNING: vmlinux(.text+0xc02da956): Section mismatch: reference to
.init.data:logo_linux_vga16 (between 'fb_find_logo' and 'schedule')
WARNING: vmlinux(.text+0xc02e0ed7): Section mismatch: reference to
.init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.data+0xc03ad099): Section mismatch: reference to
.init.text:xen_start_kernel (between 'startup_xen' and 'boot_gdt_descr')
  CC      arch/i386/boot/version.o


....



Regards,

Gabriel C

