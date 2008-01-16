Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYAPT7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYAPT7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYAPT7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:59:05 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:10197 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYAPT7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:59:04 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [patch 0/2] serial: explicitly request ttyS0-3 for COM1-4
Date: Wed, 16 Jan 2008 12:59:27 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080116170541.511233227@ldl.fc.hp.com> <20080116183933.GB23371@flint.arm.linux.org.uk>
In-Reply-To: <20080116183933.GB23371@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801161259.28723.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 January 2008 11:39:34 am Russell King wrote:
> On Wed, Jan 16, 2008 at 10:05:41AM -0700, Bjorn Helgaas wrote:
> > When 8250_pnp discovers COM ports, we only get the correct ttyS names
> > by accident -- we rely on serial8250_isa_init_ports(), which discovers
> > the COM ports earlier using the addresses in SERIAL_PORT_DFNS.
> 
> It's not by accident but by design.  It's quite intentional that it
> remembers the addresses of serial ports, and if another port is
> registered later with the same base address, it gets the same name.

It's certainly by design that if we register a port twice, it gets
the same name both times.

But that's not quite what I was referring to.  I meant that I don't
think 8250_pnp should depend on the fact that COM1-4 have been
previously discovered to get the right names.

Bjorn
