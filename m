Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170Ab0AVE1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab0AVE1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564Ab0AVE1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:27:18 -0500
Received: from trinity.fluff.org ([89.16.178.74]:46263 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab0AVE1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:27:17 -0500
Date: Fri, 22 Jan 2010 04:27:08 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>
Subject: Re: linux-next: spi tree build failure
Message-ID: <20100122042708.GK10014@trinity.fluff.org>
References: <20100122152152.5666ccab.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100122152152.5666ccab.sfr@canb.auug.org.au>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 03:21:52PM +1100, Stephen Rothwell wrote:
> Hi Grant,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> ERROR: "clk_get_rate" [drivers/spi/dw_spi_mmio.ko] undefined!
> ERROR: "clk_enable" [drivers/spi/dw_spi_mmio.ko] undefined!
> ERROR: "clk_get" [drivers/spi/dw_spi_mmio.ko] undefined!
> ERROR: "clk_put" [drivers/spi/dw_spi_mmio.ko] undefined!
> ERROR: "clk_disable" [drivers/spi/dw_spi_mmio.ko] undefined!
> 
> Caused by commit f7b6fd6d1d3833529f1626c761ba7e338586d35e ("Memory-mapped
> dw_spi driver").

sounds like someone forgot to tmake the driver dependant on HAVE_CLK
 
> I have used the spi tree from next-20100120 again for today.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/



-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

