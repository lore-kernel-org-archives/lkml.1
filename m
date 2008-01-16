Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbYAPSkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbYAPSkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 13:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYAPSkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 13:40:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50948 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYAPSkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 13:40:09 -0500
Date: Wed, 16 Jan 2008 18:39:34 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/2] serial: explicitly request ttyS0-3 for COM1-4
Message-ID: <20080116183933.GB23371@flint.arm.linux.org.uk>
References: <20080116170541.511233227@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116170541.511233227@ldl.fc.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 10:05:41AM -0700, Bjorn Helgaas wrote:
> When 8250_pnp discovers COM ports, we only get the correct ttyS names
> by accident -- we rely on serial8250_isa_init_ports(), which discovers
> the COM ports earlier using the addresses in SERIAL_PORT_DFNS.

It's not by accident but by design.  It's quite intentional that it
remembers the addresses of serial ports, and if another port is
registered later with the same base address, it gets the same name.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
