Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbXFYGNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbXFYGNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 02:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbXFYGNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 02:13:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536AbXFYGNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 02:13:16 -0400
Date: Sun, 24 Jun 2007 23:12:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux v2.6.22-rc6
Message-ID: <alpine.LFD.0.98.0706242307520.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm happy to say that things seem to have calmed down after -rc5, and that 
most of this really is just bugfixes and regression fixing in particular.

Knock wood.

So nothing really too exciting here, but hopefully we're getting closer to 
a real 2.6.22 release. Please *do* test it, and in particular people who 
have been involved with regressions, please check that the ones that 
should be fixed are really fixed, and remind people about anything that is 
still pending.

		Linus

---
Andi Kleen (9):
      x86_64: Fix readahead/sync_file_range/fadvise64 compat calls
      x86_64: Fix eventd/timerfd syscalls
      x86: Disable DAC on VIA bridges
      x86_64: Quieten Atari keyboard warnings in Kconfig
      x86: Only make Macintosh drivers default on Macs
      x86: Disable KPROBES with DEBUG_RODATA for now
      x86: change_page_attr bandaids
      i386: Make CMPXCHG64 only dependent on PAE
      x86_64: Ignore compat mode SYSCALL when IA32_EMULATION is not defined

Andy Whitcroft (2):
      update checkpatch.pl to version 0.05
      update checkpatch.pl to version 0.06

Arjan van de Ven (1):
      Allow DEBUG_RODATA and KPROBES to co-exist

Bartlomiej Zolnierkiewicz (1):
      pata_it821x: (partially) fix DMA in RAID mode

Ben Dooks (6):
      SM501: suspend support
      SM501: initialise SDRAM clock before bus clocks
      SM501: Fix sm501_init_reg() mask/set order
      SM501: Clock updates and checks
      SM501: Add Documentation/SM501.txt
      SM501: Check SM501 ID register on initialisation

Benjamin Herrenschmidt (2):
      Fix signalfd interaction with thread-private signals
      [POWERPC] Fix snd-powermac refcounting bugs

Carlos E. Ugarte (1):
      ieee1394: fix to ether1394_tx in ether1394.c

Carsten Otte (1):
      ext2: disallow setting xip on remount

Cedric Le Goater (1):
      fix refcounting of nsproxy object when unshared

Christoph Hellwig (1):
      [XFS] s/memclear_highpage_flush/zero_user_page/

Christoph Lameter (3):
      SLUB: fix behavior if the text output of list_locations overflows PAGE_SIZE
      sched: fix next_interval determination in idle_balance()
      slab allocators: MAX_ORDER one off fix

Cornelia Huck (1):
      s390: Use ccw_device_get_id() in qeth/claw drivers

Dave Hansen (1):
      document nlink function

David Brownell (1):
      [AVR32] Initialize dma_mask and dma_coherent_mask

David Howells (1):
      [AF_RXRPC]: Return the number of bytes buffered in rxrpc_send_data()

David S. Miller (1):
      [PPP]: Revert 606f585e363527da9feaed79465132c0c661fd9e

Divy Le Ray (5):
      cxgb3 - fix skb->dev dereference
      cxgb3 - fix netpoll hanlder
      cxgb3 - Fix direct XAUI support
      cxgb3 - Stop mac RX when changing MTU
      cxgb3 - MAC watchdog update

Doug Chapman (1):
      [SCSI] fusion: fix for BZ 8426 - massive slowdown on SCSI CD/DVD drive

Egmont Koblinger (1):
      console UTF-8 fixes (fix)

Florian Westphal (1):
      [TIPC]: Fix infinite loop in netlink handler

Frank Pavlic (1):
      s390: qeth: wrong packet length in qdio header

Gregory Haskins (1):
      natsemi irq flags

Haavard Skinnemoen (2):
      [AVR32] Fix bug in invalidate_dcache_region()
      [AVR32] Update defconfigs

Heiko Carstens (4):
      [S390] Fix yet another two section mismatches.
      [S390] Print list of modules on die().
      [S390] Add oops_enter()/oops_exit() calls to die().
      [S390] Move psw_set_key.

Helge Deller (1):
      [PARISC] Handle wrapping in expand_upwards()

Henrik Kretzschmar (1):
      kerneldoc fix in libata

Hugh Dickins (1):
      page_mapping must avoid slub pages

Ingo Korb (1):
      Char: stallion, fix oops during init with ISA cards

Ingo Molnar (1):
      sched: fix SysRq-N (normalize RT tasks)

Ivan Kokshaysky (1):
      alpha: fix alignment problem in csum_ipv6_magic()

Jack Morgenstein (2):
      IB/mlx4: Handle buffer wraparound in __mlx4_ib_cq_clean()
      IB/mlx4: Correct max_srq_wr returned from mlx4_ib_query_device()

Jay Vosburgh (2):
      bonding: Fix use after free in unregister path
      bonding: Fix 802.3ad no carrier on "no partner found" instance

Jean Delvare (1):
      hwmon/coretemp: fix a broken error path

Jeff Dike (1):
      uml: add asm/paravirt.h

Jens Axboe (1):
      [TCP] tcp_read_sock: Allow recv_actor() return return negative error value.

Jerome Borsboom (1):
      [NETFILTER]: nf_conntrack_sip: add missing message types containing RTP info

Jonathan Corbet (1):
      "volatile considered harmful"

Joshua Wise (1):
      x86_64: fix misplaced `continue' in mce.c

Julian Stecklina (1):
      [PARISC] stop lcd driver from stripping initial whitespace

Kaz Kojima (1):
      sh: Fix restartable syscall arg5 clobbering.

Kirill Korotaev (2):
      ext3: lost brelse in ext3_read_inode()
      ext4: lost brelse in ext4_read_inode()

Konstantin Sharlaimov (1):
      [PPP]: Fix osize too small errors when decoding mppe.

Kristian Høgsberg (1):
      firewire: Only set client->iso_context if allocation was successful.

Li Yang (2):
      [POWERPC] rheap - eliminates internal fragments caused by alignment
      Fix up CREDIT entry ordering

Linas Vepstas (5):
      spidernet: null out skb pointer after its been used.
      spidernet: Cure RX ram full bug
      spidernet: Don't terminate the RX ring
      spidernet: silence the ramfull messages
      spidernet: turn off descriptor chain end interrupt.

Linus Torvalds (2):
      Fix possible runqueue lock starvation in wait_task_inactive()
      Linus 2.6.22-rc6

Martin Schwidefsky (1):
      s390: netiucv inlining cleanup

Michael Holzheu (2):
      [S390] Missing blank when appending cio_ignore kernel parameter
      [S390] Fix zfcpdump header

Michael S. Tsirkin (2):
      IPoIB/cm: Initialize RX before moving QP to RTR
      IPoIB/cm: Fix interoperability when MTU doesn't match

Mike Frysinger (3):
      Blackfin arch: add missing braces around array bfin serial init
      Blackfin arch: move cond_syscall() behind __KERNEL__ like all other architectures
      Blackfin arch: add proper const volatile to addr argument to the read functions

Myron Stowe (1):
      ACPICA: fix error path in new external package objects as method arguments

Neil Horman (1):
      [IPVS]: Fix state variable on failure to start ipvs threads

Nick Piggin (1):
      uml: use generic BUG

Olaf Hering (1):
      x86_64: Fix only make Macintosh drivers default on Macs

Olaf Kirch (1):
      [NET]: Make skb_seq_read unmap the last fragment

Patrick McHardy (2):
      [XFRM]: Fix MTU calculation for non-ESP SAs
      [SKBUFF]: Fix incorrect config #ifdef around skb_copy_secmark

Paul Mundt (3):
      sh: oops_enter()/oops_exit() in die().
      sh: Handle -ERESTART_RESTARTBLOCK for restartable syscalls.
      sh64: Handle -ERESTART_RESTARTBLOCK for restartable syscalls.

Peer Chen (1):
      PATA: Add the MCP73/77 support to PATA driver

Ralf Baechle (1):
      [MIPS] Don't drag a platform specific header into generic arch code.

Randolph Chung (2):
      [PARISC] Fix unwinder on 64-bit kernels
      [PARISC] unwinder improvements

Robin Getz (3):
      Blackfin arch: update ANOMALY handling
      Blackfin arch: update printk to use KERN_EMERG and reformat crash output
      Blackfin arch: match kernel startup messaage with new linker script

Roland Dreier (8):
      IB/mlx4: Fix handling of wq->tail for send completions
      IB/mlx4: Fix warning in rounding up queue sizes
      IB/mlx4: Handle new FW requirement for send request prefetching
      IB/mlx4: Get rid of max_inline_data calculation
      IB/mlx4: Handle FW command interface rev 3
      IB/mlx4: Make sure inline data segments don't cross a 64 byte boundary
      IB/umem: Fix possible hang on process exit
      IPoIB/cm: Remove dead definition of struct ipoib_cm_id

Satyam Sharma (1):
      [IPV4]: include sysctl.h from inetdevice.h

Segher Boessenkool (1):
      [POWERPC] PowerPC: Prevent data exception in kernel space (32-bit)

Shannon Nelson (1):
      [NET]: Re-enable irqs before pushing pending DMA requests

Sonic Zhang (1):
      Blackfin arch: Add definition of dma_mapping_error

Stas Sergeev (1):
      fix module_param mistake in it821x

Stefan Richter (1):
      firewire: fix hang after card ejection

Stephen Hemminger (1):
      spidernet: checksum and ethtool

Tejun Heo (2):
      libata: more NONCQ devices
      ahci: fix PORTS_IMPL override

Thomas Bogendoerfer (1):
      [SCSI] ESP: Don't forget to clear ESP_FLAG_RESETTING.

Thomas Gleixner (4):
      Revert "futex_requeue_pi optimization"
      s390: netiucv spinlock initializer cleanup
      posix-timers: Prevent softirq starvation by small intervals and SIG_IGN
      FUTEX: Restore the dropped ERSCH fix

Thomas Renninger (1):
      ACPI: gracefully print null trip-point device

Tian Kevin (1):
      ACPI: preserve the ebx value in acpi_copy_wakeup_routine

Tim Mann (1):
      forcedeth: use unicast receive mode for WoL

Tim Shimmin (1):
      [XFS] Update the MAINTAINERS file entry for XFS - change git repo name.

Timothy Shimmin (1):
      [XFS] Update the MAINTAINERS file entry for XFS.

Tony Breeds (1):
      [POWERPC] Fix powermac late initcall to only run on powermac

Tony Jones (1):
      audit: fix oops removing watch if audit disabled

Ursula Braun (4):
      s390: print correct level for HiperSockets devices
      s390: qeth driver does not recover
      s390: avoid inconsistent lock state in qeth
      s390: don't call iucv_path_connect from tasklet context

Venkatesh Pallipadi (1):
      ACPI: fix 2.6.20 SMP boot regression

Wang Zhenyu (1):
      [AGPGART] intel_agp: don't load if no IGD and AGP port

YOSHIFUJI Hideaki (1):
      [IPV6] NDISC: Fix thinko to control Router Preference support.

Yasuyuki Kozakai (1):
      [NETFILTER]: nfctnetlink: Don't allow to change helper

Yinghai Lu (1):
      x86_64: fix link warning between for .text and .init.text

ben.nizette@iinet.net.au (1):
      [AVR32] NGW100, Remove relics of the old USART mapping scheme

