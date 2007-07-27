Return-Path: <linux-kernel-owner+w=401wt.eu-S965387AbXG0URX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965387AbXG0URX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937073AbXG0UQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:16:00 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:53723 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965277AbXG0UP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:15:58 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch] x86, serial: always probe for legacy COM ports
Date: Fri, 27 Jul 2007 14:11:41 -0600
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>, Adam Belay <ambx1@neo.rr.com>,
       Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       =?iso-8859-15?q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200707271158.50028.bjorn.helgaas@hp.com> <46AA33FF.4070504@garzik.org>
In-Reply-To: <46AA33FF.4070504@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707271411.42253.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 July 2007 12:05:51 pm Jeff Garzik wrote:
> Bjorn Helgaas wrote:
> > Andrew, if you drop
> >     revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
> > and apply this, we should have the previous behavior.  I think the
> > conversion to platform devices is still worthwhile.  Obviously, I intend
> > this as 2.6.23 material.
> > 
> > 
> > Always probe for serial ports at legacy addresses, even if we have PNPBIOS
> > or ACPI that should tell us about those ports.
> > 
> > We have no reports yet of defective firmware that completely omits ports.
> > However, Sébastien Dugué <sebastien.dugue@bull.net> reported that the
> > NEC Express5800/120Lh with Phoenix BIOS 6.0.5N52, released 7/12/2005,
> > reports COM2 first, then COM1 in the ACPI namespace.
> > 
> > 8250_pnp currently registers devices in namespace order.  On this machine,
> > that makes ttyS0=COM2 and ttyS1=COM1, the reverse of what we want.
> > 
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> This is still incomplete, as repeatedly stated.  Here is the email, again.

OK, uncle!  I'll work on your helpful advice (thanks for that), but
it feels too risky for this stage of 2.6.23.  Maybe I can come up with
something for a future release.

Bjorn
