Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYGUEDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYGUEDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 00:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbYGUEDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 00:03:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:33849 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbYGUEDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 00:03:03 -0400
Date: Sun, 20 Jul 2008 20:47:12 -0700
From: Greg KH <greg@kroah.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v3] Add GPIO-based MMC/SD driver
Message-ID: <20080721034712.GA25422@kroah.com>
References: <200807202148.59851.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807202148.59851.mb@bu3sch.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 09:48:58PM +0200, Michael Buesch wrote:
> This driver hooks up the mmc_spi and spi_gpio modules so that
> MMC/SD cards can be used on a GPIO based bus by bitbanging
> the SPI protocol in software.
> 
> This driver provides a configfs interface to dynamically create
> and destroy GPIO-based MMC/SD card interfaces. It also provides
> a platform device interface API.
> See Documentation/gpiommc.txt for details.

configfs stuff should still go in Documentation/ABI as it is a
userspace/kernelspace interface.

thanks,

greg k-h
