Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab0APFl2 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 00:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356Ab0APFl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 00:41:27 -0500
Received: from waste.org ([173.11.57.241]:54315 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab0APFl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 00:41:27 -0500
Subject: flash_platform_data namespace collision
From: Matt Mackall <mpm@selenic.com>
To: David Brownell <david-b@pacbell.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Linux Mailing List <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 23:41:15 -0600
Message-ID: <1263620475.29868.6280.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a board here with SPI, NOR, and NAND flash devices and I've
just run into a namespace collision on flash_platform_data from

 include/spi/flash.h

and

 arch/arm/include/asm/mach/flash.h

And each appears to have a bunch of users.

-- 
http://selenic.com : development and support for Mercurial and Linux


