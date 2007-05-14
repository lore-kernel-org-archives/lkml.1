Return-Path: <linux-kernel-owner+w=401wt.eu-S1760896AbXENJO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896AbXENJO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbXENJOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:14:52 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2114 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbXENJOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:14:52 -0400
Date: Mon, 14 May 2007 10:14:33 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mike Rapoport <mike@compulab.co.il>
Cc: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
Subject: Re: pxamci.c fails to compile
Message-ID: <20070514091433.GA13199@flint.arm.linux.org.uk>
Mail-Followup-To: Mike Rapoport <mike@compulab.co.il>, drzeus-mmc@drzeus.cx,
	linux-kernel@vger.kernel.org
References: <46481C2C.8030402@compulab.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46481C2C.8030402@compulab.co.il>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 11:22:04AM +0300, Mike Rapoport wrote:
> The PXA MMC controller does not compile for PXA27x after MMC
> reorganization, because it uses protocol defines to implement HW erratum
> workaround (lines 232 - 247 of drivers/mmc/host/pxamci.c ).
> The following patch fixes it

It's been discussed over the last few days, and the conclusion that has
been reached is that the work-around is in fact itself buggy.  The real
fix should be merged soon.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
