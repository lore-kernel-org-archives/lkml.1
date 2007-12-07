Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbXLGVvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbXLGVvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 16:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbXLGVvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 16:51:38 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51056 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754642AbXLGVvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 16:51:37 -0500
Date: Fri, 7 Dec 2007 21:45:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andi Kleen <andi@firstfloor.org>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071207214554.1dacbc27@the-village.bc.nu>
In-Reply-To: <47599E28.7020608@keyaccess.nl>
References: <475879CD.9080006@reed.com>
	<p733auekcly.fsf@bingen.suse.de>
	<20071207160439.71b7f46a@the-village.bc.nu>
	<20071207163116.GB5992@one.firstfloor.org>
	<20071207171957.73b619b1@the-village.bc.nu>
	<475994C5.7090307@keyaccess.nl>
	<20071207184237.04174f42@the-village.bc.nu>
	<47599E28.7020608@keyaccess.nl>
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

> > 8uS is an ISA bus transaction.
> 
> You very likely know better but just in case you're confused -- I thought it 
> was 8 cycles...

I'll double check. Its a long time since I stuck a scope on an ISA bus
