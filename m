Return-Path: <linux-kernel-owner+w=401wt.eu-S1030307AbXAYQ0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030307AbXAYQ0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030308AbXAYQ0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:26:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54764 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030307AbXAYQ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:26:35 -0500
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
	controllers
From: David Woodhouse <dwmw2@infradead.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       torvalds@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070125162255.GF31145@flint.arm.linux.org.uk>
References: <20070125150905.652f9ce2@localhost.localdomain>
	 <1169741658.3593.98.camel@shinybook.infradead.org>
	 <45B8D810.3030501@pobox.com>
	 <20070125162255.GF31145@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Fri, 26 Jan 2007 00:26:15 +0800
Message-Id: <1169742375.3593.110.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-01-25 at 16:22 +0000, Russell King wrote:
> The zero DMA address is absolutely and totally valid.  It might not
> correspond with physical address zero on platforms.
> 
> Also, DMA address zero is not the same as NULL. 

This isn't actually "DMA address" in that context -- it's the I/O port
number at which the controller's BM-DMA control registers reside. But
still it can be zero.

-- 
dwmw2

