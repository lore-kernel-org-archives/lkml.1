Return-Path: <linux-kernel-owner+w=401wt.eu-S1767484AbXECQWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767484AbXECQWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767486AbXECQWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:22:33 -0400
Received: from xenotime.net ([66.160.160.81]:57621 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1767484AbXECQWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:22:32 -0400
Date: Thu, 3 May 2007 09:26:47 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: lkml <linux-kernel@vger.kernel.org>, jwboyer@linux.vnet.ibm.com,
       grant.likely@secretlab.ca, akpm <akpm@linux-foundation.org>,
       jketreno@linux.intel.com
Subject: Re: [PATCH] lib/hexdump
Message-Id: <20070503092647.985708bb.rdunlap@xenotime.net>
In-Reply-To: <Pine.LNX.4.61.0705030859480.18504@yvahk01.tjqt.qr>
References: <20070502153556.3c995de7.randy.dunlap@oracle.com>
	<Pine.LNX.4.61.0705030859480.18504@yvahk01.tjqt.qr>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007 09:01:31 +0200 (MEST) Jan Engelhardt wrote:

> 
> On May 2 2007 15:35, Randy Dunlap wrote:
> >
> >Add hex_dumper() to lib/hexdump.c and linux/kernel.h.
> 
> Right - we've got the second user already, namely the PANIC/OOPS
> code print. (The last line, aka "bytes at EIP" under Windows.)
> 
> Jan  6 14:40:14 deekin kernel: Call Trace:
> Jan  6 14:40:14 deekin kernel:  [<c02060b3>] is_complete+0x2c3/0x310
> Jan  6 14:40:14 deekin kernel:  [<c02037c0>] run+0x30/0x40
> Jan  6 14:40:14 deekin kernel:  [<c0125b6d>] worker_thread+0x1bd/0x2b0
> Jan  6 14:40:14 deekin kernel:  [<c0203790>] run+0x0/0x40
> Jan  6 14:40:14 deekin kernel:  [<c0113b10>] default_wake_function+0x0/0x20
> Jan  6 14:40:14 deekin kernel:  [<c0108fd6>] ret_from_fork+0x6/0x20
> Jan  6 14:40:14 deekin kernel:  [<c0113b10>] default_wake_function+0x0/0x20
> Jan  6 14:40:14 deekin kernel:  [<c01259b0>] worker_thread+0x0/0x2b0
> Jan  6 14:40:14 deekin kernel:  [<c0107175>] kernel_thread_helper+0x5/0x10
> Jan  6 14:40:14 deekin kernel: Code: 89 02 8b 41 04 8b 40 3c 8b 53 04 89 42 3c
> 8b 41 04

plus intel wireless drivers, 2 MTD/flash drivers, and search
kernel tree for hexdump (function name that I wanted to use, but
it's already used), hex_dump, dump_hex, dump_mem, etc.

Andrew says that he knew of 9 hex dumpers in-tree.  :)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
(sorry about email address change; other address not working for some reason)
