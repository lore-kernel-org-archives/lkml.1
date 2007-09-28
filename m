Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbXI1KI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbXI1KI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 06:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbXI1KIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 06:08:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33557 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751637AbXI1KIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 06:08:46 -0400
Date: Fri, 28 Sep 2007 11:14:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Jeff Garzik <jeff@garzik.org>, Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, greg@kroah.com, akpm@osdl.org
Subject: Re: [PATCH][resend] PCI: fix IDE legacy mode resources
Message-ID: <20070928111408.119f0631@the-village.bc.nu>
In-Reply-To: <20070928084840.GA5542@derision.cyrius.com>
References: <20070824115559.06250ec0.yoichi_yuasa@tripeaks.co.jp>
	<20070824161442.GB15305@kroah.com>
	<20070824173713.2bc20bac@the-village.bc.nu>
	<20070928084840.GA5542@derision.cyrius.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 10:48:41 +0200
Martin Michlmayr <tbm@cyrius.com> wrote:

> * Alan Cox <alan@lxorguk.ukuu.org.uk> [2007-08-24 17:37]:
> > >>     PCI: Unable to reserve I/O region #1:8@f00001f0 for device 0000:00:09.1
> > > > In some architectures, PCI bus regions have the offset from PCI resources.
> > > > For this reason, pci_setup_device() should set PCI bus regions to dev->resource[]. 
> > > 
> > > I thought this patch was rejected in the past as it broke other
> > > machines.
> > 
> > News to me.
> > 
> > Ths one looks sane and is different to the one Andrew has been fiddling
> > with to stop broken X servers from crashing.
> 
> Can this patch be added now or does there have to be more discussion?
> I need this patch for IDE and PATA to work on my MIPS Cobalt.
> Yoichi's original patch and explanation can be found at
> http://lkml.org/lkml/2007/8/23/411

I've no idea why it hasn't been applied unless nobody is quite sure who
owns it. As a PCI fix I guess Greg does (and drop it into -mm for
testing) ?

