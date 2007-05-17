Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbXEQWOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbXEQWOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbXEQWO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:14:27 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2712 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbXEQWO0 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:14:26 -0400
Date: Thu, 17 May 2007 23:14:18 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: CIJOML <cijoml@volny.cz>
Cc: Linux-kernel@vger.kernel.org
Subject: Re: Having problems with 8250 module in 2.6.20,2.6.21...
Message-ID: <20070517221418.GA15498@flint.arm.linux.org.uk>
Mail-Followup-To: CIJOML <cijoml@volny.cz>, Linux-kernel@vger.kernel.org
References: <200705172220.10469.cijoml@volny.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705172220.10469.cijoml@volny.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 10:20:10PM +0200, CIJOML wrote:
> Hi,
> 
> with kernel 2.6.20 and 2.6.21 I have problem with my good old router 
> Dell Dual P2 333MHz.
> 
> Module 8250 getts loaded, but UPS driver is unable talk to UPS:
> 
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
> eth0:  setting full-duplex.
> eth1:  setting full-duplex.

Looks like no serial ports were found?

> ttyS0: LSR safety check engaged!
> ttyS0: LSR safety check engaged!
> ttyS1: LSR safety check engaged!
> ttyS1: LSR safety check engaged!

But something in userspace tried to add some, but they don't look like
a serial port - the LSR register contains an impossible value for a
serial port to be there.

> ttyS1: LSR safety check engaged!
> ttyS1: LSR safety check engaged!
> ttyS1: LSR safety check engaged!
> ttyS1: LSR safety check engaged!
> ttyS1: LSR safety check engaged!
> ttyS1: LSR safety check engaged!
> ttyS1: LSR safety check engaged!
> ttyS1: LSR safety check engaged!

More attempts at trying to open the nonexistent serial port.

> Does anybody work on this problem or can help?

Please track down the last kernel version which worked.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
