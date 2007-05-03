Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbXECHFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbXECHFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbXECHFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:05:30 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:50390 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbXECHFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:05:30 -0400
Date: Thu, 3 May 2007 09:01:31 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: lkml <linux-kernel@vger.kernel.org>, jwboyer@linux.vnet.ibm.com,
       grant.likely@secretlab.ca, akpm <akpm@linux-foundation.org>,
       jketreno@linux.intel.com
Subject: Re: [PATCH] lib/hexdump
In-Reply-To: <20070502153556.3c995de7.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.61.0705030859480.18504@yvahk01.tjqt.qr>
References: <20070502153556.3c995de7.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 2 2007 15:35, Randy Dunlap wrote:
>
>Add hex_dumper() to lib/hexdump.c and linux/kernel.h.

Right - we've got the second user already, namely the PANIC/OOPS
code print. (The last line, aka "bytes at EIP" under Windows.)

Jan  6 14:40:14 deekin kernel: Call Trace:
Jan  6 14:40:14 deekin kernel:  [<c02060b3>] is_complete+0x2c3/0x310
Jan  6 14:40:14 deekin kernel:  [<c02037c0>] run+0x30/0x40
Jan  6 14:40:14 deekin kernel:  [<c0125b6d>] worker_thread+0x1bd/0x2b0
Jan  6 14:40:14 deekin kernel:  [<c0203790>] run+0x0/0x40
Jan  6 14:40:14 deekin kernel:  [<c0113b10>] default_wake_function+0x0/0x20
Jan  6 14:40:14 deekin kernel:  [<c0108fd6>] ret_from_fork+0x6/0x20
Jan  6 14:40:14 deekin kernel:  [<c0113b10>] default_wake_function+0x0/0x20
Jan  6 14:40:14 deekin kernel:  [<c01259b0>] worker_thread+0x0/0x2b0
Jan  6 14:40:14 deekin kernel:  [<c0107175>] kernel_thread_helper+0x5/0x10
Jan  6 14:40:14 deekin kernel: Code: 89 02 8b 41 04 8b 40 3c 8b 53 04 89 42 3c
8b 41 04


Jan
-- 
