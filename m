Return-Path: <linux-kernel-owner+w=401wt.eu-S933666AbXCTPOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666AbXCTPOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933679AbXCTPOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:14:46 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2372 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666AbXCTPOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:14:45 -0400
Date: Tue, 20 Mar 2007 15:14:29 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Keith Owens <kaos@ocs.com.au>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PNPACPI probes serial twice, messes up serial console
Message-ID: <20070320151429.GA11578@flint.arm.linux.org.uk>
Mail-Followup-To: Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Keith Owens <kaos@ocs.com.au>, linux-kernel@vger.kernel.org,
	len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>
References: <17887.1174373206@kao2.melbourne.sgi.com> <200703200832.24921.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703200832.24921.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 08:32:24AM -0600, Bjorn Helgaas wrote:
> Index: work-mm2/include/linux/serial_8250.h
> ===================================================================
> --- work-mm2.orig/include/linux/serial_8250.h	2006-08-22 12:26:25.000000000 -0600
> +++ work-mm2/include/linux/serial_8250.h	2006-08-22 16:37:36.000000000 -0600
> @@ -44,6 +44,7 @@
>  	PLAT8250_DEV_HUB6,
>  	PLAT8250_DEV_MCA,
>  	PLAT8250_DEV_AU1X00,
> +	PLAT8250_DEV_X86,

There's no need for PLAT8250_DEV_X86 if x86 went to the model that ARM
and all the others which I did convert use - iow, PLAT8250_DEV_PLATFORM
and friends.

They're there so that the arch/* code can provide their serial port
information to the 8250 driver instead of using include/asm-*/serial.h

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
