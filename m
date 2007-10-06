Return-Path: <linux-kernel-owner+w=401wt.eu-S1762751AbXJFKIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762751AbXJFKIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 06:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbXJFKIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 06:08:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45076 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752893AbXJFKIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 06:08:38 -0400
Date: Sat, 6 Oct 2007 11:13:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Scott Simpson" <simpson100@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Conflict when loading initio driver
Message-ID: <20071006111318.1d2aab90@the-village.bc.nu>
In-Reply-To: <79759ec90710052032r577b9fey92f024d3908a56b5@mail.gmail.com>
References: <79759ec90710052032r577b9fey92f024d3908a56b5@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	host->addr = pci_resource_start(pdev, 0);
> >
> >  	if (!request_region(host->addr, 256, "i91u")) {
> >  		printk(KERN_WARNING "initio: I/O port range 0x%x is busy.\n", host->addr);
> 
> I tried this fix on my SuSE 10.3 system (2.6.22.5-29 kernel) and it
> didn't work. The system froze on boot. I think there might be more to
> it.

Can you stick some printk statements in so we can see where it hangs
roughly ? 
