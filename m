Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbYJTILs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbYJTILs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 04:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYJTILj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 04:11:39 -0400
Received: from trinity.fluff.org ([89.145.97.151]:37380 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYJTILi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 04:11:38 -0400
Date: Mon, 20 Oct 2008 10:11:27 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: David Brownell <david-b@pacbell.net>
Cc: Magnus Damm <magnus.damm@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [spi-devel-general] [patch 2.6.27-git] spi_gpio driver
Message-ID: <20081020091127.GA4413@trinity.fluff.org>
References: <200807202146.12759.mb@bu3sch.de> <200810181354.23955.david-b@pacbell.net> <aec7e5c30810191944u4c125943h895099b3f1eaa813@mail.gmail.com> <200810192124.36402.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810192124.36402.david-b@pacbell.net>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2008 at 09:24:36PM -0700, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Generalize the old at91rm9200 "bootstrap" bitbanging SPI master driver
> as "spi_gpio", so it works with arbitrary GPIOs and can be configured
> through platform_data.  Such SPI masters support:
> 
>  - any number of bus instances (bus_num is the platform_device.id)
>  - any number of chipselects (one GPIO per spi_device)
>  - all four SPI_MODE values, and SPI_CS_HIGH
>  - i/o word sizes from 1 to 32 bits;
>  - devices configured as with any other spi_master controller

Probably worth looking at removing the s3c24xx gpio specific driver and
replacing it with this.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

