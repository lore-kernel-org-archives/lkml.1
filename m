Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbYHBNXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbYHBNXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 09:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYHBNXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 09:23:09 -0400
Received: from smtp-out28.alice.it ([85.33.2.28]:3347 "EHLO
	smtp-out28.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYHBNXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 09:23:08 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Aug 2008 09:23:07 EDT
Message-ID: <48945D43.5070800@alice.it>
Date: Sat, 02 Aug 2008 15:12:35 +0200
From: Mario Vanoni <vanonim@alice.it>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080716 SeaMonkey/1.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.26.1
Content-Type: multipart/mixed;
 boundary="------------020202070201040707020507"
X-OriginalArrivalTime: 02 Aug 2008 13:12:52.0027 (UTC) FILETIME=[780080B0:01C8F4A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020202070201040707020507
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

NOT in LKML, cc if needed please

Works perfectly on 3 machines, static kernel, now >4h.

Compilation gives WARNING: ... Section mismatch ...,
see attach compiled with
make CONFIG_DEBUG_SECTION_MISMATCH=y -j 2 bzImage 2> kernel.stderr

Slackware 12.1, gcc 4.2.3, Intel Core 2 6320, 4GB mem.

Congrats for the updated kernel
Mario Vanoni

--------------020202070201040707020507
Content-Type: text/plain;
 name="kernel.stderr"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel.stderr"

WARNING: arch/x86/kernel/built-in.o(.text+0x104de): Section mismatch in reference from the function cpu_exit_clear() to the function .cpuinit.text:cpu_uninit()
The function cpu_exit_clear() references
the function __cpuinit cpu_uninit().
This is often because cpu_exit_clear lacks a __cpuinit 
annotation or the annotation of cpu_uninit is wrong.

WARNING: kernel/built-in.o(.text+0x51e1): Section mismatch in reference from the function init_hrtick() to the variable .cpuinit.data:hotplug_hrtick_nb.31442
The function init_hrtick() references
the variable __cpuinitdata hotplug_hrtick_nb.31442.
This is often because init_hrtick lacks a __cpuinitdata 
annotation or the annotation of hotplug_hrtick_nb.31442 is wrong.

fs/autofs4/symlink.c: In function 'autofs4_follow_link':
fs/autofs4/symlink.c:18: warning: passing argument 2 of 'nd_set_link' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:210: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:216: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:210: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
net/bridge/br_netfilter.c: In function 'br_nf_forward_arp':
net/bridge/br_netfilter.c:717: warning: passing argument 4 of 'nf_hook_thresh' discards qualifiers from pointer target type
net/bridge/br_netfilter.c:717: warning: passing argument 5 of 'nf_hook_thresh' discards qualifiers from pointer target type
drivers/ide/pci/aec62xx.c: In function 'init_chipset_aec62xx':
drivers/ide/pci/aec62xx.c:146: warning: passing argument 2 of 'pci_set_drvdata' discards qualifiers from pointer target type
drivers/ide/pci/aec62xx.c:148: warning: passing argument 2 of 'pci_set_drvdata' discards qualifiers from pointer target type
drivers/ide/pci/hpt366.c: In function 'hpt366_init_one':
drivers/ide/pci/hpt366.c:1588: warning: passing argument 2 of 'pci_set_drvdata' discards qualifiers from pointer target type
drivers/ide/pci/hpt366.c:1596: warning: passing argument 2 of 'pci_set_drvdata' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:216: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:216: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:216: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:216: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:216: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:210: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:216: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:210: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:216: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:210: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memset_io':
include/asm/io_32.h:204: warning: passing argument 1 of '__constant_c_and_count_memset' discards qualifiers from pointer target type
include/asm/io_32.h:204: warning: passing argument 1 of '__constant_c_memset' discards qualifiers from pointer target type
include/asm/io_32.h:204: warning: passing argument 1 of '__memset_generic' discards qualifiers from pointer target type
include/asm/io_32.h:204: warning: passing argument 1 of '__memset_generic' discards qualifiers from pointer target type
drivers/net/wan/farsync.c: In function 'fst_intr_rx':
drivers/net/wan/farsync.c:1339: warning: cast to pointer from integer of different size
drivers/net/wan/farsync.c: In function 'do_bottom_half_tx':
drivers/net/wan/farsync.c:1437: warning: cast to pointer from integer of different size
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:210: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:216: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:210: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:216: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:210: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:216: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memset_io':
include/asm/io_32.h:204: warning: passing argument 1 of '__constant_c_and_count_memset' discards qualifiers from pointer target type
include/asm/io_32.h:204: warning: passing argument 1 of '__constant_c_memset' discards qualifiers from pointer target type
include/asm/io_32.h:204: warning: passing argument 1 of '__memset_generic' discards qualifiers from pointer target type
include/asm/io_32.h:204: warning: passing argument 1 of '__memset_generic' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:210: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:216: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
drivers/net/tun.c: In function 'tun_chr_aio_read':
drivers/net/tun.c:463: warning: passing argument 3 of 'tun_put_user' discards qualifiers from pointer target type
drivers/net/tun.c: In function 'tun_chr_aio_write':
drivers/net/tun.c:362: warning: passing argument 2 of 'tun_get_user' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:210: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:210: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
net/ipv4/netfilter/ipt_ULOG.c: In function 'ipt_ulog_packet':
net/ipv4/netfilter/ipt_ULOG.c:213: warning: passing argument 1 of '__net_timestamp' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memset_io':
include/asm/io_32.h:204: warning: passing argument 1 of '__constant_c_and_count_memset' discards qualifiers from pointer target type
include/asm/io_32.h:204: warning: passing argument 1 of '__constant_c_memset' discards qualifiers from pointer target type
include/asm/io_32.h:204: warning: passing argument 1 of '__memset_generic' discards qualifiers from pointer target type
include/asm/io_32.h:204: warning: passing argument 1 of '__memset_generic' discards qualifiers from pointer target type
WARNING: vmlinux.o(.text+0x107ee): Section mismatch in reference from the function cpu_exit_clear() to the function .cpuinit.text:cpu_uninit()
The function cpu_exit_clear() references
the function __cpuinit cpu_uninit().
This is often because cpu_exit_clear lacks a __cpuinit 
annotation or the annotation of cpu_uninit is wrong.

WARNING: vmlinux.o(.text+0x20651): Section mismatch in reference from the function init_hrtick() to the variable .cpuinit.data:hotplug_hrtick_nb.31442
The function init_hrtick() references
the variable __cpuinitdata hotplug_hrtick_nb.31442.
This is often because init_hrtick lacks a __cpuinitdata 
annotation or the annotation of hotplug_hrtick_nb.31442 is wrong.

Root device is (8, 1)
Setup is 10620 bytes (padded to 10752 bytes).
System is 3837 kB
CRC cdb3bc56

--------------020202070201040707020507--
