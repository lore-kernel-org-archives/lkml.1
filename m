Return-Path: <linux-kernel-owner+w=401wt.eu-S1945912AbXDCUbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945912AbXDCUbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945911AbXDCUbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:31:49 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46074 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945912AbXDCUbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:31:48 -0400
Subject: Re: 2.6.21-rc5-mm4
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070402224745.71a25af7.akpm@linux-foundation.org>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 13:31:51 -0700
Message-Id: <1175632311.6185.1.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 22:47 -0700, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> 

SLUB code hangs my ppc64 machine on boot.

Thanks,
Badari

booted from '/pci@800000020000003/pci@2,2/pci1069,b166@1/scsi@0/sd@4,0'
Enter "help" to get some basic usage information
boot: 2621rc5mm4
Please wait, loading kernel...
Allocated 0x00400000 bytes for executable @ 0x00400000
   Elf32 kernel loaded...

zImage starting: loaded at 0x00400000 (sp: 0x01a3fb10)
Allocating 0x822c40 bytes for kernel ...
OF version = 'IBM,SF225_096'
gunzipping (0x01c00000 <- 0x00408000:0x006a8d9b)...done 0x75cdf0 bytes
Finalizing device tree... using OF tree (promptr=00c39a50)
OF stdout device is: /vdevice/vty@30000000
Hypertas detected, assuming LPAR !
command line: root=/dev/sda2
memory layout at init:
  alloc_bottom : 0000000002427000
  alloc_top    : 0000000008000000
  alloc_top_hi : 00000001e8000000
  rmo_top      : 0000000008000000
  ram_top      : 00000001e8000000
Looking for displays
found display   : /pci@800000020000002/pci@2,2/pci@1/display@0,
opening ... done
instantiating rtas at 0x00000000077ca000 ... done
0000000000000000 : boot cpu     0000000000000000
0000000000000002 : starting cpu hw idx 0000000000000002... done
0000000000000004 : starting cpu hw idx 0000000000000004... done
0000000000000006 : starting cpu hw idx 0000000000000006... done
copying OF device tree ...
Building dt strings...
Building dt structure...
Device tree strings 0x0000000002428000 -> 0x00000000024292fe
Device tree struct  0x000000000242a000 -> 0x000000000243f000
Calling quiesce ...
returning from prom_init
Partition configured for 8 cpus.
Starting Linux PPC64 #1 SMP Tue Apr 3 10:42:07 PDT 2007
-----------------------------------------------------
ppc64_pft_size                = 0x1b
physicalMemorySize            = 0x1e8000000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0x0000000000000000
htab_hash_mask                = 0xfffff
-----------------------------------------------------
Linux version 2.6.21-rc5-mm4-ppc64 (root@elm3a121) (gcc version 4.1.0
(SUSE Linux)) #1 SMP Tue Apr 3 10:42:07 PDT 2007
[boot]0012 Setup Arch
No ramdisk, default root is /dev/sda2
EEH: PCI Enhanced I/O Error Handling Enabled
PPC64 nvram contains 8192 bytes
Zone PFN ranges:
  DMA             0 ->  1998848
  Normal    1998848 ->  1998848
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->   974848
    1:   974848 ->  1998848
[boot]0015 Setup Done
Built 2 zonelists.  Total pages: 1971520
Kernel command line: root=/dev/sda2
[boot]0020 XICS Init
[boot]0021 XICS Done
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour dummy device 80x25
console handover: boot [udbg-1] -> real [hvc0]
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
freeing bootmem node 0
freeing bootmem node 1
Memory: 7855400k/7995392k available (6060k kernel code, 139992k
reserved, 1236k data, 819k bss, 272k init)
SLUB V6: General Slabs=18, HW alignment=128, Processors=8, Nodes=16





