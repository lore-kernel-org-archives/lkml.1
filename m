Return-Path: <linux-kernel-owner+w=401wt.eu-S933968AbXLQALY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968AbXLQALY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 19:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764117AbXLQAKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 19:10:50 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48552 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760102AbXLQAKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 19:10:48 -0500
Date: Mon, 17 Dec 2007 00:03:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>, unlisted-recipients: no@elvis.elte.hu,
       To-header@elvis.elte.hu, on@elvis.elte.hu, "input <"@elvis.elte.hu,
       "; Rene Herman" <rene.herman@keyaccess.nl>,
       Paul Rolland <rol@as2917.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
	Cc:	;Rene Herman <rene.herman@keyaccess.nl>
			^-extraneous tokens in mailbox, missing end of mailbox
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
	Cc:	;Rene Herman <rene.herman@keyaccess.nl>
			^-extraneous tokens in mailbox, missing end of mailbox
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071217000301.1c280daa@the-village.bc.nu>
In-Reply-To: <20071216212628.GF14265@elf.ucw.cz>
References: <20071211163706.2dc82275@tux.DEF.witbe.net>
	<475EB263.2050405@keyaccess.nl>
	<475EC1C0.2040000@reed.com>
	<20071211173231.2b87a81f@the-village.bc.nu>
	<475EE2CA.6020601@reed.com>
	<Pine.LNX.4.61.0712111513490.23653@chaos.analogic.com>
	<475F23BD.3040903@reed.com>
	<Pine.LNX.4.61.0712120802300.4443@chaos.analogic.com>
	<20071212161245.3f388229@the-village.bc.nu>
	<20071214143328.GB10130@elte.hu>
	<20071216212628.GF14265@elf.ucw.cz>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Dec 2007 22:26:33 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> On Fri 2007-12-14 15:33:28, Ingo Molnar wrote:
> > 
> > * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > 
> > > There is another reason we can't just do a dumb changeover - two 
> > > actually
> > > 
> > > #1: Some drivers are using inb_p/outb_p in PCI cases which are going 
> > > #to cause PCI posting changes. Most are probably just wrong in the 
> > > #first place but they need hand checking
> > 
> > hm, any intelligent way to force PCI posting? I guess not.
> > 
> > here's a list of candidate drivers (match the out*_p() pattern and do 
> > pci)
> > 
> > ./char/epca.c 
> > ./char/sonypi.c
> > ./scsi/megaraid.c
> > ./ide/pci/serverworks.c
> > ./ide/pci/cmd640.c
> > ./input/mouse/pc110pad.c

You are missing some watchdogs at least ?
