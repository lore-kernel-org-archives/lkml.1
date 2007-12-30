Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbXL3VnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbXL3VnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXL3VnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:43:17 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50927 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751103AbXL3VnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:43:16 -0500
Date: Sun, 30 Dec 2007 21:33:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Bodo Eggert <7eggert@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230213309.70d9d1e0@the-village.bc.nu>
In-Reply-To: <20071230210007.GA3136@elte.hu>
References: <9FXbU-3M4-11@gated-at.bofh.it>
	<9G2Om-4hg-1@gated-at.bofh.it>
	<9G7O3-3O2-7@gated-at.bofh.it>
	<9G8qN-4TX-13@gated-at.bofh.it>
	<E1J92JB-00013N-P3@be1.7eggert.dyndns.org>
	<20071230181004.GA21968@elte.hu>
	<477805F1.4070201@zytor.com>
	<20071230210007.GA3136@elte.hu>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ok. Like the patch below?

Not quite - you still need the loop in case you NMI and then run off into
oblivion
