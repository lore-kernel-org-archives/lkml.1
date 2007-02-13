Return-Path: <linux-kernel-owner+w=401wt.eu-S1750922AbXBMKyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750922AbXBMKyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXBMKyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:54:20 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4939 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbXBMKyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:54:19 -0500
Date: Tue, 13 Feb 2007 10:54:11 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] fix error management in 8250_pci.c pciserial_resume_one
Message-ID: <20070213105411.GA6883@flint.arm.linux.org.uk>
Mail-Followup-To: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
References: <20070213113010.27125d53@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213113010.27125d53@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 11:30:10AM +0100, Stefano Brivio wrote:
>   CC      drivers/serial/8250_pci.o
> drivers/serial/8250_pci.c: In function 'pciserial_resume_one':
> drivers/serial/8250_pci.c:1830: warning: ignoring return value of 'pci_enable_device', declared with attribute warn_unused_result
> 
> This patch fixes it.

Oh for god sake, this does not fix anything.  It creates more problems
than it solves.

Next time, check the mailing list archives and you'll see this is not
the first time this has come up.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
