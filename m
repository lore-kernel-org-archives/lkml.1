Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbZEAMhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbZEAMhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbZEAMhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:37:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58461 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZEAMhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:37:02 -0400
Date: Fri, 1 May 2009 13:36:45 +0100
From: Russell King <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.arm.linux.org.uk
Cc: Michal Simek <monstr@monstr.eu>, linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/27] asm-generic: add legacy I/O header files
Message-ID: <20090501123645.GB27799@flint.arm.linux.org.uk>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Michal Simek <monstr@monstr.eu>, linux-arch@vger.kernel.org,
	Remis Lima Baima <remis.developer@googlemail.com>,
	linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <10b3a32656e5552458db7412ef9ff8530d5f92aa.1241105648.git.arnd@arndb.de> <c1a198be0904302309w4154f97dqddd0b2df1924a821@mail.gmail.com> <200905011422.29753.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905011422.29753.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 02:22:29PM +0200, Arnd Bergmann wrote:
> drivers/rtc/rtc-pxa.c:#define TIMER_FREQ                CLOCK_TICK_RATE

Needs to use some separate definition, this is not related in any way
to the ISA timer stuff.

> drivers/serial/serial_ks8695.c:         .uartclk        = CLOCK_TICK_RATE * 16,

Ditto.

> drivers/watchdog/davinci_wdt.c: timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) & 0xffffffff);
> drivers/watchdog/davinci_wdt.c: timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) >> 32);

Ditto.

> drivers/watchdog/ks8695_wdt.c:  unsigned long tval = wdt_time * CLOCK_TICK_RATE;

Ditto.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
