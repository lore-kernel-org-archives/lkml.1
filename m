Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbYAPKzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbYAPKzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 05:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYAPKzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 05:55:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:58623 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYAPKzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 05:55:36 -0500
From: Stefan Roese <sr@denx.de>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: ppc: 4xx: sysctl table check failed: /kernel/l2cr .1.31 Missing strategy
Date: Wed, 16 Jan 2008 11:55:15 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Josh Boyer <jwboyer@gmail.com>, Wolfgang Denk <wd@denx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801161155.15676.sr@denx.de>
X-Provags-ID: V01U2FsdGVkX18srJdjeYqlpHQA5t917q2dZuYP7zJnjh6ERog
 Vgh35ZbF4i7AINa7PWKHiwbmdBCJ1vGQyTYVrtt9AXlNIbwQLM
 kjmgl5RQAr+8NtLNEQrxa8pT5/7sTxD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing this error message when booting an recent arch/ppc kernel on
4xx platforms (tested on Ocotea and other 4xx platforms). Booting NFS
rootfs still works fine, but this message kind of makes me "nervous".
This is not seen on 4xx arch/powerpc platforms. Here the bootlog:

Linux version 2.6.24-rc8 (stefan@ubuntu) (gcc version 4.2.2) #1 Wed Jan 16 11:51:57 CET 2008
IBM Ocotea port (MontaVista Software, Inc. <source@mvista.com>)
Zone PFN ranges:
  DMA             0 ->    65536
  Normal      65536 ->    65536
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->    65536
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
Kernel command line: root=/dev/nfs rw nfsroot=192.168.1.1:/opt/eldk-4.1/ppc_4xx ip=192.168.80.2:192.168.1.1::255.255.0.0:ocotea:eth0:off panic=1 console=ttyS0,115200
PID hash table entries: 1024 (order: 10, 4096 bytes)
console [ttyS0] enabled
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 257536k available (1660k kernel code, 540k data, 104k init, 0k highmem)
SLUB: Genslabs=11, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Mount-cache hash table entries: 512
net_namespace: 64 bytes
NET: Registered protocol family 16
PCI: Probing PCI hardware
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
sysctl table check failed: /kernel/l2cr .1.31 Missing strategy
Call Trace:
[cfc11df0] [c00082d0] show_stack+0x44/0x1ac (unreliable)
[cfc11e30] [c0034ffc] set_fail+0x50/0x68
[cfc11e50] [c0035428] sysctl_check_table+0x414/0x70c
[cfc11ec0] [c003543c] sysctl_check_table+0x428/0x70c
[cfc11f30] [c0021fe4] register_sysctl_table+0x64/0xb4
[cfc11f50] [c0213858] register_ppc_htab_sysctl+0x18/0x2c
[cfc11f60] [c02121f4] kernel_init+0xd0/0x2b0
[cfc11ff0] [c0003b3c] kernel_thread+0x44/0x60
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
...

Any ideas?

Thanks.

Best regards,
Stefan
