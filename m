Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbXL3VlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbXL3VlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXL3VlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:41:00 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36765 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751033AbXL3Vk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:40:59 -0500
Date: Sun, 30 Dec 2007 21:31:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: 7eggert@gmx.de, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230213114.25139163@the-village.bc.nu>
In-Reply-To: <4778052E.8000808@zytor.com>
References: <9FXbU-3M4-11@gated-at.bofh.it>
	<9G2Om-4hg-1@gated-at.bofh.it>
	<9G7O3-3O2-7@gated-at.bofh.it>
	<9G8qN-4TX-13@gated-at.bofh.it>
	<E1J92JB-00013N-P3@be1.7eggert.dyndns.org>
	<4778052E.8000808@zytor.com>
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

On Sun, 30 Dec 2007 12:53:02 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Bodo Eggert wrote:
> > 
> > I've never seen code which would do that, and it was not suggested by any
> > tutorial I ever saw. I'd expect any machine to break on all kinds of software
> > if it required this. The only thing I remember being warned about is writing
> > the index and the data register at the same time using outw, because that
> > would write both registers at the same time on 16-bit-cards.
> > 
> 
> And we use that, and have been for 15 years.  I haven't seen any screams 
> of pain about it.

Actually there were, and I sent numerous people patches for that back in
ISA days. 

Alan
