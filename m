Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab0APRsP (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 12:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252Ab0APRsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 12:48:14 -0500
Received: from waste.org ([173.11.57.241]:44463 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab0APRsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 12:48:13 -0500
Subject: Re: flash_platform_data namespace collision
From: Matt Mackall <mpm@selenic.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: David Brownell <david-b@pacbell.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Mailing List <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>
In-Reply-To: <20100116110420.GB31282@flint.arm.linux.org.uk>
References: <1263620475.29868.6280.camel@calx>
	 <20100116110420.GB31282@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Jan 2010 11:47:59 -0600
Message-ID: <1263664079.29868.6289.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-16 at 11:04 +0000, Russell King wrote:
> On Fri, Jan 15, 2010 at 11:41:15PM -0600, Matt Mackall wrote:
> > I've got a board here with SPI, NOR, and NAND flash devices and I've
> > just run into a namespace collision on flash_platform_data from
> 
> The one in arch/arm/include/asm/mach/flash.h is designed to have great
> appeal and flexibility across different platforms, and indeed we have
> at least 70 users across six different MTD NOR flash drivers and two
> MTD NAND drivers.
> 
> If anything, I believe that this header should move into linux/mtd/
> and become a standard structure for platforms to communicate their
> requirements to flash drivers.

Yeah, I think this is probably the way to go. Davids, any objections?

-- 
http://selenic.com : development and support for Mercurial and Linux


