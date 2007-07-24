Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbXGXHd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbXGXHd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbXGXHdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:33:51 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:46687 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbXGXHdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:33:50 -0400
Date: Tue, 24 Jul 2007 08:33:31 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Bill Gatliff <bgat@billgatliff.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: pxa timer code broken for non-CONFIG_GENERIC_CLOCKEVENTS
Message-ID: <20070724073330.GA14217@flint.arm.linux.org.uk>
References: <20070724042947.GM1678@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724042947.GM1678@pengutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 06:29:47AM +0200, Robert Schwebel wrote:
> Bill,
> 
> 7bbb18c9f4783b6fb3bf27af71625b590cf4f00b aka 4507/1 intensively uses
> stuff from include/linux/clockchips.h which are defined under
> 
> #ifdef CONFIG_GENERIC_CLOCKEVENTS
> 
> Unless I'm missing something, all PXA platforms which have
> CONFIG_GENERIC_CLOCKEVENTS not set are currently broken and don't
> compile any more.

I'm not sure what the point of this message is.  You'll find a fix for
this on linux-arm-kernel since yesterday morning.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
