Return-Path: <linux-kernel-owner+w=401wt.eu-S964828AbXBTMDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbXBTMDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 07:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964836AbXBTMDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 07:03:07 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44436 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964828AbXBTMDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 07:03:05 -0500
Date: Tue, 20 Feb 2007 13:06:34 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Andrew Morton <akpm@osdl.org>, <linux-kernel@vger.kernel.org>,
       <rmk@arm.linux.org.uk>, <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH 2/2] Use resource_size_t for serial port IO addresses
Message-ID: <20070220130634.72b9a02b@localhost.localdomain>
In-Reply-To: <20070220031951.5D53BDDD0E@ozlabs.org>
References: <20070220031717.GI17818@localhost.localdomain>
	<20070220031951.5D53BDDD0E@ozlabs.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 14:19:51 +1100 (EST)
David Gibson <david@gibson.dropbear.id.au> wrote:

> At present, various parts of the serial code use unsigned long to
> define resource addresses.  This is a problem, because some 32-bit
> platforms have physical addresses larger than 32-bits, and have mmio
> serial uarts located above the 4GB point.
> 
> This patch changes the type of mapbase in both struct uart_port and
> struct plat_serial8250_port to resource_size_t, which can be
> configured to be 64 bits on such platforms.  The mapbase in
> serial_struct can't safely be changed, because that structure is user
> visible.
> 
> Signed-off-by: David Gibson <dwg@au1.ibm.com>

Acked-by: Alan Cox <alan@redhat.com>
