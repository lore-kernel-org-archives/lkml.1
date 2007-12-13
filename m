Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbXLMN25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbXLMN25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbXLMN2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:28:47 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33725 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752513AbXLMN2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:28:46 -0500
Date: Thu, 13 Dec 2007 13:21:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: David Newall <david@davidnewall.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Paul Rolland <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071213132112.66d59aa2@the-village.bc.nu>
In-Reply-To: <47612FF9.8060402@reed.com>
References: <475879CD.9080006@reed.com>
	<p733auekcly.fsf@bingen.suse.de>
	<20071207160439.71b7f46a@the-village.bc.nu>
	<20071209125458.GB4381@ucw.cz>
	<20071209165908.GA15910@one.firstfloor.org>
	<20071209212513.GC24284@elf.ucw.cz>
	<475CBDD7.5050602@keyaccess.nl>
	<m3bq8y23de.fsf@maximus.localdomain>
	<475DE37F.20706@davidnewall.com>
	<475DE6F4.80702@zytor.com>
	<475DEB23.1000304@davidnewall.com>
	<20071211084059.3d03e11d@tux.DEF.witbe.net>
	<475E5D4B.8020101@keyaccess.nl>
	<475E7DC2.4060509@davidnewall.com>
	<475E8D91.20201@keyaccess.nl>
	<475E95A3.3070801@davidnewall.com>
	<20071211142552.2ae6ea9a@the-village.bc.nu>
	<47605E4B.6050904@davidnewall.com>
	<20071212230030.00511c3f@the-village.bc.nu>
	<47612FF9.8060402@reed.com>
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

On Thu, 13 Dec 2007 08:13:29 -0500
"David P. Reed" <dpreed@reed.com> wrote:

> Perhaps what was meant is that ISA-tuned timings make little sense on 
> devices that are part of the chipset or on the PCI or PCI-X buses?

No.

ISA as LPC bus is alive and well inside and outside chipsets. Welcome to
planet earth and the reality of 'its cheaper to reuse cells than design a
new one'. For the chipset logic like DMA controllers the _p is absolutely
correct.

Alan
