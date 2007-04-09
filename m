Return-Path: <linux-kernel-owner+w=401wt.eu-S1751292AbXDILgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbXDILgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 07:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXDILge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 07:36:34 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4311 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbXDILge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 07:36:34 -0400
Date: Mon, 9 Apr 2007 12:36:27 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] pata_icside driver
Message-ID: <20070409113627.GB26874@flint.arm.linux.org.uk>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070330110022.GA21653@flint.arm.linux.org.uk> <20070330110800.GB21653@flint.arm.linux.org.uk> <20070408101826.GA5431@flint.arm.linux.org.uk> <20070408195956.4e7d50c0@the-village.bc.nu> <461990CE.8080609@pobox.com> <20070409105638.6b131b72@the-village.bc.nu> <461A1BEA.7000002@pobox.com> <461A1FC1.50809@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461A1FC1.50809@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 07:13:05AM -0400, Jeff Garzik wrote:
> It should be noted, mainly for russell's benefit, that the ->irq_ack() 
> hook is only called if a debug define is manually enabled in libata.h, 
> in a single callsite.
> 
> The number of people that actually use the hook -- kernel hackers 
> debugging screaming interrupts -- can probably be counted on one hand.

Ok, in that case it makes sense for me to set this to ata_dummy_irq_ack
since I don't have any additional status registers specific to the
interface.

Presumably a similar change to pata_platform.c would be appropriate?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
