Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbYJTTLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbYJTTLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 15:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYJTTLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 15:11:40 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:37551 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYJTTLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 15:11:39 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: n0ano@n0ano.com
Subject: Re: [PATCH] Enable console on PCI serial devices
Date: Mon, 20 Oct 2008 13:11:05 -0600
User-Agent: KMail/1.9.9
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, donald.d.dugger@intel.com,
       linux-kernel@vger.kernel.org
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <200810201111.08703.bjorn.helgaas@hp.com> <20081020174351.GK14490@xolotl.n0ano.com>
In-Reply-To: <20081020174351.GK14490@xolotl.n0ano.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201311.06602.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2008 11:43:51 am n0ano@n0ano.com wrote:
> On Mon, Oct 20, 2008 at 11:11:07AM -0600, Bjorn Helgaas wrote:
> >... 
> > It doesn't bother me that the number is large.  It's only a factor
> > of 16 bigger than the baud rate.  It is sort of magic, but on the
> > other hand, the number is often printed on a part on the board, so
> > it's easy to determine, and fairly easy to document.  If you've
> > lost the box with the marketing messages on it, I'd argue that it's
> > easier to determine the clock rate than the fastest baud rate.
> > 
> > To me it seems more confusing to specify two baud rates: the one
> > you want to use, and the fastest one the UART supports.
> 
> Well, how about consistency with the current serial driver.  The
> current driver uses base baud, as evidenced by this code from
> `drivers/serial/8250_pci.c':
> 
> static struct pciserial_board pci_boards[] __devinitdata = {
>         [pbn_default] = {
>                 .flags          = FL_BASE0,
>                 .num_ports      = 1,
>                 .base_baud      = 115200,
>                 .uart_offset    = 8,
>         },
> 
> I think it's even more important to follow what the driver is
> doing.  (If I'd lost the bix I would get the PCI IDs and see
> what the driver is doing for my unknown card :-)

Ideally we could put something in Documentation/kernel-parameters.txt
that's useful for people who can't or don't want to look at
the source.

Bjorn
