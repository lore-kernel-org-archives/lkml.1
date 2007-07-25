Return-Path: <linux-kernel-owner+w=401wt.eu-S933190AbXGYPoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbXGYPoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760091AbXGYPo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:44:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35524 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758935AbXGYPo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:44:27 -0400
Date: Wed, 25 Jul 2007 16:48:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeff Garzik <jeff@garzik.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       =?UTF-8?B?U8ODwqliYXN0aWVu?= =?UTF-8?B?IER1Z3XDg8Kp?= 
	<sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
Message-ID: <20070725164808.41404dc7@the-village.bc.nu>
In-Reply-To: <p73ir88sax1.fsf@bingen.suse.de>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	<200707241434.32374.bjorn.helgaas@hp.com>
	<46A663CA.3050000@garzik.org>
	<200707241456.35769.bjorn.helgaas@hp.com>
	<46A669AD.6070803@garzik.org>
	<20070724230753.4d681104@the-village.bc.nu>
	<p73ir88sax1.fsf@bingen.suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 Jul 2007 18:30:50 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> > > That cannot be a justification for breaking serial port probe that has 
> > > been working for 10+ years.
> > 
> > Agree. With my "nearest thing we have to a serial maintainer" hat on
> > please revert this Andrew. Bjorn - lets discuss putting the right APIs in
> > place so you can busy out serial ports from other drivers when they are a
> > shared resource.
> 
> One alternative would be to make the default behaviour dependent on 
> DMI year and acpi enabled. On modern systems with ACPI ACPI serial
> probing should work (modulo bugs which can be probably worked out) 
> Let's say >= 2003 ? 

That isn't the problem with the IR stuff. In many cases the user wants
the port to be showing up as a serial port for SIR usage. We need a clean
automatic SIR/FIR switching for them. It has nothing to do with whether
the ACPI data is trustworthy or not.

Alan
