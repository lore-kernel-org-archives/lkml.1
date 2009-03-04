Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbZCDD6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbZCDD6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 22:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZCDD6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 22:58:23 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:45692 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZCDD6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 22:58:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=i12vOXHBI2BqS5BdDQE3M0pf0Lh7wjRpLScH8pOdg+W7OaGyMdWLPIFcZyp5pl66og
         ag6N4f85vEY9sF9sbbNJUYbQ/kNbiZ8vky/P84NtRjeTGe/cXCECSJXgNzD+UbpwmBRt
         yjQam75yGeIxzFjEJmChpUN9OKZVkBTgCZubU=
MIME-Version: 1.0
In-Reply-To: <49ADE201.7010506@kernel.org>
References: <86802c440903031458p4a72f8c8x6f91e9f58ac6bc26@mail.gmail.com>
	 <86802c440903031751y136b506uc163dd2c9023de9b@mail.gmail.com>
	 <49ADE201.7010506@kernel.org>
Date: Tue, 3 Mar 2009 19:58:19 -0800
X-Google-Sender-Auth: aeadc02f911eae0d
Message-ID: <86802c440903031958k7bbadd9dka240b11fb07f9395@mail.gmail.com>
Subject: Re: 32bit panic on 4 sockets
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2g x4

bootmem::init_bootmem_core nid=0 start=0 map=11 end=b79fe mapsize=16f40
  mapped low ram: 0 - b79fe000
  low ram: 00000000 - b79fe000
  bootmap 00011000 - 00027f40
bootmem::mark_bootmem_node nid=0 start=10 end=99 reserve=0 flags=0
bootmem::__free nid=0 start=10 end=99
bootmem::mark_bootmem_node nid=0 start=100 end=7d800 reserve=0 flags=0
bootmem::__free nid=0 start=100 end=7d800
bootmem::mark_bootmem_node nid=0 start=7ea00 end=80000 reserve=0 flags=0
bootmem::__free nid=0 start=7ea00 end=80000
bootmem::mark_bootmem_node nid=-1879510539 start=80000 end=b79fe reserve=0 flags
BUG: Int 6: CR2 00d0fff6
     EDI 000b79fe  ESI 00080000  EBP 40c15ea8  ESP 40c15e8c
     EBX (null)  EDX 00000006  ECX 0000f3f3  EAX f000eef3
     err (null)  EIP 40c321c9   CS 00000060  flg 00010013
Stack: 00000002 00000001 000b79fe 40c15eb8 40c3231a (null) (null) 40c15ecc
       40c32f91 00000001 00011000 c3a024c0 40c15edc 40c2d309 00000930 (null)
       40c15f24 40c2e3de 00000040 26e00000 00000002 00004c00 28000000 00000002
Pid: 0, comm: swapper Not tainted 2.6.29-rc6-tip-02441-g4239438 #697
Call Trace:
 [<407d4f2f>] ? printk+0xf/0x11
 [<40c321c9>] ? mark_bootmem_node+0x44/0x7d
 [<40c3231a>] ? free_bootmem_node+0x20/0x24
 [<40c32f91>] ? free_bootmem_with_active_regions+0x63/0x94
 [<40c2d309>] ? setup_bootmem_allocator+0xe4/0x12e
 [<40c2e3de>] ? initmem_init+0x60e/0x620
 [<40c3a067>] ? acpi_table_parse+0x66/0x6f
 [<40c208a2>] ? setup_arch+0x759/0x95a
 [<40240e74>] ? up+0x2b/0x2f
 [<40c22c33>] ? __reserve_early+0xe4/0xf8
 [<40c1d56d>] ? start_kernel+0x6d/0x2c8
 [<40c1d085>] ? __init_begin+0x85/0x8d


4g x 4

High memory starts at vaddr f79fe000
bootmem::init_bootmem_core nid=0 start=0 map=11 end=b79fe mapsize=16f40
  mapped low ram: 0 - b79fe000
  low ram: 00000000 - b79fe000
  bootmap 00011000 - 00027f40
bootmem::mark_bootmem_node nid=0 start=10 end=9c reserve=0 flags=0
bootmem::__free nid=0 start=10 end=9c
bootmem::mark_bootmem_node nid=0 start=100 end=87fe0 reserve=0 flags=0
bootmem::__free nid=0 start=100 end=87fe0
(14 early reservations) ==> bootmem [0000000000 - 00b79fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
bootmem::mark_bootmem_node nid=0 start=0 end=1 reserve=1 flags=0
bootmem::__reserve nid=0 start=0 end=1 flags=0
bootmem::__reserve silent double reserve of PFN 0
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
bootmem::mark_bootmem_node nid=0 start=1 end=2 reserve=1 flags=0
bootmem::__reserve nid=0 start=1 end=2 flags=0
bootmem::__reserve silent double reserve of PFN 1
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
bootmem::mark_bootmem_node nid=0 start=6 end=7 reserve=1 flags=0
bootmem::__reserve nid=0 start=6 end=7 flags=0
bootmem::__reserve silent double reserve of PFN 6
  #3 [0000200000 - 0000da6874]    TEXT DATA BSS ==> [0000200000 - 0000da6874]
bootmem::mark_bootmem_node nid=0 start=200 end=da7 reserve=1 flags=0
bootmem::__reserve nid=0 start=200 end=da7 flags=0
  #4 [007ea35000 - 007ffffe57]          RAMDISK ==> [007ea35000 - 007ffffe57]
bootmem::mark_bootmem_node nid=0 start=7ea35 end=80000 reserve=1 flags=0
bootmem::__reserve nid=0 start=7ea35 end=80000 flags=0
  #5 [0000da7000 - 0000db2000]    INIT_PG_TABLE ==> [0000da7000 - 0000db2000]
bootmem::mark_bootmem_node nid=0 start=da7 end=db2 reserve=1 flags=0
bootmem::__reserve nid=0 start=da7 end=db2 flags=0
  #6 [000009c800 - 0000100000]    BIOS reserved ==> [000009c800 - 0000100000]
bootmem::mark_bootmem_node nid=0 start=9c end=100 reserve=1 flags=0
bootmem::__reserve nid=0 start=9c end=100 flags=0
bootmem::__reserve silent double reserve of PFN 9c
bootmem::__reserve silent double reserve of PFN 9d
bootmem::__reserve silent double reserve of PFN 9e
bootmem::__reserve silent double reserve of PFN 9f
bootmem::__reserve silent double reserve of PFN a0
bootmem::__reserve silent double reserve of PFN a1
bootmem::__reserve silent double reserve of PFN a2
bootmem::__reserve silent double reserve of PFN a3
bootmem::__reserve silent double reserve of PFN a4
bootmem::__reserve silent double reserve of PFN a5
bootmem::__reserve silent double reserve of PFN a6
bootmem::__reserve silent double reserve of PFN a7
bootmem::__reserve silent double reserve of PFN a8
bootmem::__reserve silent double reserve of PFN a9
bootmem::__reserve silent double reserve of PFN aa
bootmem::__reserve silent double reserve of PFN ab
bootmem::__reserve silent double reserve of PFN ac
bootmem::__reserve silent double reserve of PFN ad
bootmem::__reserve silent double reserve of PFN ae
bootmem::__reserve silent double reserve of PFN af
bootmem::__reserve silent double reserve of PFN b0
bootmem::__reserve silent double reserve of PFN b1
bootmem::__reserve silent double reserve of PFN b2
bootmem::__reserve silent double reserve of PFN b3
bootmem::__reserve silent double reserve of PFN b4
bootmem::__reserve silent double reserve of PFN b5
bootmem::__reserve silent double reserve of PFN b6
bootmem::__reserve silent double reserve of PFN b7
bootmem::__reserve silent double reserve of PFN b8
bootmem::__reserve silent double reserve of PFN b9
bootmem::__reserve silent double reserve of PFN ba
bootmem::__reserve silent double reserve of PFN bb
bootmem::__reserve silent double reserve of PFN bc
bootmem::__reserve silent double reserve of PFN bd
bootmem::__reserve silent double reserve of PFN be
bootmem::__reserve silent double reserve of PFN bf
bootmem::__reserve silent double reserve of PFN c0
bootmem::__reserve silent double reserve of PFN c1
bootmem::__reserve silent double reserve of PFN c2
bootmem::__reserve silent double reserve of PFN c3
bootmem::__reserve silent double reserve of PFN c4
bootmem::__reserve silent double reserve of PFN c5
bootmem::__reserve silent double reserve of PFN c6
bootmem::__reserve silent double reserve of PFN c7
bootmem::__reserve silent double reserve of PFN c8
bootmem::__reserve silent double reserve of PFN c9
bootmem::__reserve silent double reserve of PFN ca
bootmem::__reserve silent double reserve of PFN cb
bootmem::__reserve silent double reserve of PFN cc
bootmem::__reserve silent double reserve of PFN cd
bootmem::__reserve silent double reserve of PFN ce
bootmem::__reserve silent double reserve of PFN cf
bootmem::__reserve silent double reserve of PFN d0
bootmem::__reserve silent double reserve of PFN d1
bootmem::__reserve silent double reserve of PFN d2
bootmem::__reserve silent double reserve of PFN d3
bootmem::__reserve silent double reserve of PFN d4
bootmem::__reserve silent double reserve of PFN d5
bootmem::__reserve silent double reserve of PFN d6
bootmem::__reserve silent double reserve of PFN d7
bootmem::__reserve silent double reserve of PFN d8
bootmem::__reserve silent double reserve of PFN d9
bootmem::__reserve silent double reserve of PFN da
bootmem::__reserve silent double reserve of PFN db
bootmem::__reserve silent double reserve of PFN dc
bootmem::__reserve silent double reserve of PFN dd
bootmem::__reserve silent double reserve of PFN de
bootmem::__reserve silent double reserve of PFN df
bootmem::__reserve silent double reserve of PFN e0
bootmem::__reserve silent double reserve of PFN e1
bootmem::__reserve silent double reserve of PFN e2
bootmem::__reserve silent double reserve of PFN e3
bootmem::__reserve silent double reserve of PFN e4
bootmem::__reserve silent double reserve of PFN e5
bootmem::__reserve silent double reserve of PFN e6
bootmem::__reserve silent double reserve of PFN e7
bootmem::__reserve silent double reserve of PFN e8
bootmem::__reserve silent double reserve of PFN e9
bootmem::__reserve silent double reserve of PFN ea
bootmem::__reserve silent double reserve of PFN eb
bootmem::__reserve silent double reserve of PFN ec
bootmem::__reserve silent double reserve of PFN ed
bootmem::__reserve silent double reserve of PFN ee
bootmem::__reserve silent double reserve of PFN ef
bootmem::__reserve silent double reserve of PFN f0
bootmem::__reserve silent double reserve of PFN f1
bootmem::__reserve silent double reserve of PFN f2
bootmem::__reserve silent double reserve of PFN f3
bootmem::__reserve silent double reserve of PFN f4
bootmem::__reserve silent double reserve of PFN f5
bootmem::__reserve silent double reserve of PFN f6
bootmem::__reserve silent double reserve of PFN f7
bootmem::__reserve silent double reserve of PFN f8
bootmem::__reserve silent double reserve of PFN f9
bootmem::__reserve silent double reserve of PFN fa
bootmem::__reserve silent double reserve of PFN fb
bootmem::__reserve silent double reserve of PFN fc
bootmem::__reserve silent double reserve of PFN fd
bootmem::__reserve silent double reserve of PFN fe
bootmem::__reserve silent double reserve of PFN ff
  #7 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
bootmem::mark_bootmem_node nid=0 start=10 end=11 reserve=1 flags=0
bootmem::__reserve nid=0 start=10 end=11 flags=0
  #8 [0174e00000 - 0178000000]          KVA RAM
  #9 [0275e00000 - 0278000000]          KVA RAM
  #10 [0375e00000 - 0378000000]          KVA RAM
  #11 [0475e00000 - 0478000000]          KVA RAM
  #12 [0075200000 - 007ea00000]           KVA PG ==> [0075200000 - 007ea00000]
bootmem::mark_bootmem_node nid=0 start=75200 end=7ea00 reserve=1 flags=0
bootmem::__reserve nid=0 start=75200 end=7ea00 flags=0
  #13 [0000011000 - 0000028000]          BOOTMAP ==> [0000011000 - 0000028000]
bootmem::mark_bootmem_node nid=0 start=11 end=28 reserve=1 flags=0
bootmem::__reserve nid=0 start=11 end=28 flags=0
bootmem::alloc_bootmem_core nid=0 size=4000 [4 pages] align=40 goal=0 limit=ffff
bootmem::__reserve nid=0 start=28 end=2c flags=1
