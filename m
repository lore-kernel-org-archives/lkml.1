Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbYITNJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbYITNJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 09:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYITNJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 09:09:47 -0400
Received: from sh-virus-4.gradwell.net ([193.84.87.106]:34884 "EHLO
	sh-virus-4.gradwell.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbYITNJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 09:09:46 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Sep 2008 09:09:45 EDT
Date: Sat, 20 Sep 2008 14:03:19 +0100
From: Alex Buell <alex.buell@munted.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Bad page state error?
Message-Id: <20080920140319.f133bfe7.alex.buell@munted.org.uk>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happened earlier this morning; 

Sep 20 11:40:38 lithium Bad page state in process 'tclsh'
Sep 20 11:40:38 lithium page:c1d90004 flags:0x00000001 mapping:00000000 mapcount:1 count:0
Sep 20 11:40:38 lithium Trying to fix it up, but a reboot is needed
Sep 20 11:40:38 lithium Backtrace:
Sep 20 11:40:38 lithium Pid: 10896, comm: tclsh Tainted: PF        2.6.25-gentoo-r7 #1
Sep 20 11:40:38 lithium [<c0141037>] bad_page+0x52/0x7a
Sep 20 11:40:38 lithium [<c01416d3>] free_hot_cold_page+0x5b/0x18d
Sep 20 11:40:38 lithium [<c0141819>] __pagevec_free+0x14/0x1a
Sep 20 11:40:38 lithium [<c0143d0d>] release_pages+0x13f/0x147
Sep 20 11:40:38 lithium [<c0146e16>] __inc_zone_state+0x10/0x5e
Sep 20 11:40:38 lithium [<c0143dab>] __pagevec_lru_add_active+0x96/0xa1
Sep 20 11:40:38 lithium [<c0143f42>] drain_cpu_pagevecs+0x2f/0x4c
Sep 20 11:40:38 lithium [<c0143fac>] lru_add_drain+0x14/0x31
Sep 20 11:40:38 lithium [<c014b753>] exit_mmap+0x16/0xf4
Sep 20 11:40:38 lithium [<c011ba5b>] mmput+0x20/0x78
Sep 20 11:40:38 lithium [<c015c169>] flush_old_exec+0x509/0x78d
Sep 20 11:40:38 lithium [<c01588ae>] vfs_read+0xe3/0xf4
Sep 20 11:40:38 lithium [<c015b6f0>] kernel_read+0x32/0x43
Sep 20 11:40:38 lithium [<c017db58>] load_elf_binary+0x359/0x1139
Sep 20 11:40:38 lithium [<c014a3f4>] get_user_pages+0x24f/0x2c5
Sep 20 11:40:38 lithium [<c015b1f3>] get_arg_page+0x2b/0x7b
Sep 20 11:40:38 lithium [<c015b497>] search_binary_handler+0xba/0x20c
Sep 20 11:40:38 lithium [<c017d7ff>] load_elf_binary+0x0/0x1139
Sep 20 11:40:38 lithium [<c015c7d0>] do_execve+0x122/0x16a
Sep 20 11:40:38 lithium [<c01023de>] sys_execve+0x2a/0x4f
Sep 20 11:40:38 lithium [<c0103b6a>] sysenter_past_esp+0x5f/0x85
Sep 20 11:40:38 lithium [<c0370000>] smp_store_cpu_info+0xae/0xb2
Sep 20 11:40:38 lithium =======================

Does anyone knows what happened? This on a Dell Inspiron 5150 w/ 2GB ram, w/ 250GB hard disk, and 3.06GHz Pentium IV, kernel is 2.6.25.

If you need any additional details, ask. 
-- 
http://www.munted.org.uk

Fearsome grindings.
