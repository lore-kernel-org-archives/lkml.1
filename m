Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0APLEq (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 06:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164Ab0APLEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 06:04:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58098 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab0APLEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 06:04:44 -0500
Date: Sat, 16 Jan 2010 11:04:20 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Matt Mackall <mpm@selenic.com>
Cc: David Brownell <david-b@pacbell.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Mailing List <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>
Subject: Re: flash_platform_data namespace collision
Message-ID: <20100116110420.GB31282@flint.arm.linux.org.uk>
References: <1263620475.29868.6280.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263620475.29868.6280.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 11:41:15PM -0600, Matt Mackall wrote:
> I've got a board here with SPI, NOR, and NAND flash devices and I've
> just run into a namespace collision on flash_platform_data from

The one in arch/arm/include/asm/mach/flash.h is designed to have great
appeal and flexibility across different platforms, and indeed we have
at least 70 users across six different MTD NOR flash drivers and two
MTD NAND drivers.

If anything, I believe that this header should move into linux/mtd/
and become a standard structure for platforms to communicate their
requirements to flash drivers.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
