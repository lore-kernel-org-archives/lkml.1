Return-Path: <linux-kernel-owner+w=401wt.eu-S934456AbXGYR2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456AbXGYR2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758482AbXGYR20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:28:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56682 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932158AbXGYR2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:28:25 -0400
Date: Wed, 25 Jul 2007 18:34:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andi Kleen <andi@firstfloor.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       =?UTF-8?B?U8OpYmFzdGllbiBE?= =?UTF-8?B?dWd1w6k=?= 
	<sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
Message-ID: <20070725183434.7902c953@the-village.bc.nu>
In-Reply-To: <46A77E92.6020902@garzik.org>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	<p73ir88sax1.fsf@bingen.suse.de>
	<20070725164808.41404dc7@the-village.bc.nu>
	<200707251006.42948.bjorn.helgaas@hp.com>
	<46A77E92.6020902@garzik.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 12:47:14 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Bjorn Helgaas wrote:
> > The IR driver would be the clear owner of the entire device.  Of course,
> > this still only works if we get rid of the 8250 blind probe for 0x3e8
> > or figure out some API for the IR driver to tell the 8250 driver to get
> > its mitts off.
> 
> 
> Load driver B before loading driver A.

Completely impractical. Devices may be hotplug, there may be combinations
of ordering required and since you have to build serial in for serial
console its a total non starter


Alan
