Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbYCUKzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbYCUKzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 06:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbYCUKzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 06:55:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41599 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753890AbYCUKzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 06:55:36 -0400
Date: Fri, 21 Mar 2008 10:40:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: "Peter F. Patel-Schneider" <pfps@verizon.net>,
       linux-kernel@vger.kernel.org,
       "Peter F. Patel-Schneider" <pfps@research.bell-labs.com>
Subject: Re: 2.6.23-rc9-git4: pata_pcmcia, disabling IRQ #9 and Re: libata
 and legacy ide pcmcia failure
Message-ID: <20080321104002.27a7d19e@core>
In-Reply-To: <47E31197.70003@gmail.com>
References: <47067DB9.80200@roarinelk.homelinux.net>
	<47E300B2.7000104@verizon.net>
	<20080321011205.4c7b4a61@core>
	<47E31197.70003@gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008 10:38:31 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Alan Cox wrote:
> > O> Mar 20 19:51:45 idefix kernel: ata12: PATA max PIO0 cmd 0xa100 ctl 
> >> 0xa10e irq 3
> >> Mar 20 19:52:15 idefix kernel: ata12.00: qc timeout (cmd 0x91)
> >> Mar 20 19:52:15 idefix kernel: ata12.00: failed to IDENTIFY 
> >> (INIT_DEV_PARAMS failed, err_mask=0x4)
> > 
> > Thinkpad T61p .. I've seen a few of these.
> > 
> > Firstly try the card and adapter in a different PC and let me know if
> > that works. So far they do. If that is the case get the latest firmware
> > updates (BIOS etc) for your thinkpad and see if the problem goes away.
> > They (or our ACPI code I guess it may be) have some serious IRQ routing
> > problems on this box.
> 
> Any chance the thing just chokes up on INIT_DEV_PARAMS?

Possibly but I've seen several previosu reports showing no IRQ being
delivered off these machines. You get IRQ 3 reported as assigned and an
IRQ 9 turns up.

Alan
