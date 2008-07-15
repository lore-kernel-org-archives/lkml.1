Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYGOFHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYGOFHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYGOFGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:06:54 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:63682
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbYGOFGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:06:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogAAEzNe0jLrQkK/2dsb2JhbAAIrQo
X-IronPort-AV: E=Sophos;i="4.30,364,1212336000"; 
   d="scan'208";a="289779361"
Subject: Re: [PATCH] Add dynamic MMC-over-SPI-GPIO driver
From: Ben Nizette <bn@niasdigital.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org
In-Reply-To: <200807142109.19360.mb@bu3sch.de>
References: <200807142109.19360.mb@bu3sch.de>
Content-Type: text/plain
Organization: Nias Digital
Date: Tue, 15 Jul 2008 15:06:49 +1000
Message-Id: <1216098409.4265.144.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-07-14 at 21:09 +0200, Michael Buesch wrote:
> This driver provides a sysfs interface to dynamically create
> and destroy GPIO-based MMC/SD card interfaces.
> So an MMC or SD card can be connected to generic GPIO pins
> and be configured dynamically from userspace.

Can you use mmc-spi attached to spi-gpio and be done with it?  Sure you
won't have the dynamic alloc capability but you won't be reinventing the
wheel either.  You don't have dynamic creation for any other platform
device and if you need it then, IMO, it'd be better solved in a more
generic way.

btw, what's this spi-gpio thing?  I can't see it in mainline except in a
s3c24xx specific way.  My domestic blindness??

	--Ben.


