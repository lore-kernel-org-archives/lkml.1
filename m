Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbXLaOkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbXLaOkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 09:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXLaOkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 09:40:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:52676 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXLaOkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 09:40:07 -0500
Date: Mon, 31 Dec 2007 15:39:02 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: "H. Peter Anvin" <hpa@zytor.com>, 7eggert@gmx.de,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
In-Reply-To: <20071230213114.25139163@the-village.bc.nu>
Message-ID: <alpine.LSU.0.999.0712311517360.4211@be1.lrz>
References: <9FXbU-3M4-11@gated-at.bofh.it> <9G2Om-4hg-1@gated-at.bofh.it>
 <9G7O3-3O2-7@gated-at.bofh.it> <9G8qN-4TX-13@gated-at.bofh.it>
 <E1J92JB-00013N-P3@be1.7eggert.dyndns.org> <4778052E.8000808@zytor.com>
 <20071230213114.25139163@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/uLooNCfLmPokCZcMkOZZXeiFCwCeQ3KvGZYG
 nNJM1gxFQSGTI135SPz279d/OI34lj51SlNCliTqMihNH3fZPK
 Fa29S2yWZbqimcHsnk93w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Dec 2007, Alan Cox wrote:
> On Sun, 30 Dec 2007 12:53:02 -0800
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> > Bodo Eggert wrote:

> > > I've never seen code which would do that, and it was not suggested by any
> > > tutorial I ever saw. I'd expect any machine to break on all kinds of software
> > > if it required this. The only thing I remember being warned about is writing
> > > the index and the data register at the same time using outw, because that
> > > would write both registers at the same time on 16-bit-cards.
> > > 
> > 
> > And we use that, and have been for 15 years.  I haven't seen any screams 
> > of pain about it.
> 
> Actually there were, and I sent numerous people patches for that back in
> ISA days. 

Are you talking about VGA cards requiring a delay between outb index/outb 
data, VGA cards barfing on outw or systems barfing on outb(0x80,42)?
-- 
Programming is an art form that fights back.
