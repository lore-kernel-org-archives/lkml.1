Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbXGKHS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbXGKHS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbXGKHSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:18:48 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:44111 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXGKHSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:18:48 -0400
Date: Wed, 11 Jul 2007 08:17:42 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: do not add port that is not initialized
Message-ID: <20070711071742.GA12952@flint.arm.linux.org.uk>
References: <200707101703.36173.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707101703.36173.yinghai.lu@sun.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 05:03:35PM -0700, Yinghai Lu wrote:
> [PATCH] serial: do not add port that is not initialized
> 
> if the port is not initialized with correct iobase, and membase, we don't
> need to add that port.
> for x86, when pnpacpi is enabled, we will not get extra ttyS1/ttyS2/ttyS3 in
> /sys/devices/platform/serial8250/tty
> 
> Sign-off-by: Yinghai Lu <yinghai.lu@sun.com>

What if someone wants to run setserial on /dev/ttyS1 to set it's base
address, irq and other parameters?  People still do this.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
