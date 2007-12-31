Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbXLaQHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbXLaQHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbXLaQHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:07:06 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51885 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750797AbXLaQHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:07:03 -0500
Date: Mon, 31 Dec 2007 15:56:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bodo Eggert <7eggert@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, 7eggert@gmx.de,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071231155657.59fe8494@the-village.bc.nu>
In-Reply-To: <alpine.LSU.0.999.0712311517360.4211@be1.lrz>
References: <9FXbU-3M4-11@gated-at.bofh.it>
	<9G2Om-4hg-1@gated-at.bofh.it>
	<9G7O3-3O2-7@gated-at.bofh.it>
	<9G8qN-4TX-13@gated-at.bofh.it>
	<E1J92JB-00013N-P3@be1.7eggert.dyndns.org>
	<4778052E.8000808@zytor.com>
	<20071230213114.25139163@the-village.bc.nu>
	<alpine.LSU.0.999.0712311517360.4211@be1.lrz>
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

On Mon, 31 Dec 2007 15:39:02 +0100 (CET)
> > Actually there were, and I sent numerous people patches for that back in
> > ISA days. 
> 
> Are you talking about VGA cards requiring a delay between outb index/outb 
> data, VGA cards barfing on outw or systems barfing on outb(0x80,42)?

VGA cards barfing on outw - on some trident at least it would cause weird
display messups when scrolling the text console that went right the next
scroll.
