Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbXGCOAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbXGCOAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbXGCOAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:00:49 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33614 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754055AbXGCOAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:00:48 -0400
Date: Tue, 3 Jul 2007 15:06:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: 2.6.22-rc6-mm1 bad_page events.
Message-ID: <20070703150656.4f618dd5@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

X86 32bit with lots of debug turned on I get this:



Freeing unused kernel memory: 156k freed
Write protecting the kernel text: 1668k
Write protecting the kernel read-only data: 719k
Bad page state in process 'swapper'
page:c10000c0 flags:0x00000400 mapping:00000000 mapcount:0 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
 [<c024589c>] bad_page+0x6c/0x100
 [<c024648d>] free_hot_cold_page+0x5d/0x140
 [<c02116c2>] global_flush_tlb+0x112/0x130
 [<c020102d>] init_post+0xd/0xe0
 [<c047c876>] kernel_init+0x216/0x220
 [<c0214c50>] schedule_tail+0x0/0xe0
 [<c047c660>] kernel_init+0x0/0x220
 [<c047c660>] kernel_init+0x0/0x220
 [<c0204227>] kernel_thread_helper+0x7/0x10
 =======================
Hexdump:
000: 00 06 00 00 01 00 00 00 ff ff ff ff 0f 00 00 00
010: 00 00 00 00 00 00 00 00 78 00 00 c1 b8 00 00 c1
020: 00 06 00 00 01 00 00 00 ff ff ff ff a7 03 00 00
030: 00 00 00 00 00 00 00 00 98 00 00 c1 d8 00 00 c1
040: 00 04 00 00 00 00 00 00 ff ff ff ff 00 00 00 00
050: 00 00 00 00 00 00 00 00 b8 00 00 c1 f8 00 00 c1
060: 00 06 00 00 01 00 00 00 ff ff ff ff 00 04 00 00
070: 00 00 00 00 00 00 00 00 d8 00 00 c1 18 01 00 c1
080: 00 06 00 00 01 00 00 00 ff ff ff ff 9c 03 00 00
090: 00 00 00 00 00 00 00 00 f8 00 00 c1 38 01 00 c1
0a0: 00 06 00 00 01 00 00 00 ff ff ff ff 00 04 00 00
0b0: 00 00 00 00 00 00 00 00 18 01 00 c1 58 01 00 c1
