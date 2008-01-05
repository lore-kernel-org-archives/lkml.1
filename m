Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbYAEVte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbYAEVte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757235AbYAEVt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:49:27 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:59888 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757128AbYAEVt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:49:26 -0500
Date: Sat, 5 Jan 2008 21:49:16 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.24-rc6-mm 4/9] gpiolib: avr32 at32ap platform
 support
Message-ID: <20080105214916.7c67a522@siona>
In-Reply-To: <200801051210.56567.david-b@pacbell.net>
References: <200712281927.32575.david-b@pacbell.net>
	<200712281956.33051.david-b@pacbell.net>
	<200801051210.56567.david-b@pacbell.net>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008 12:10:56 -0800
David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Teach AVR32 to use the "GPIO Library" when exposing its GPIOs, so that
> signals on external chips (like GPIO expanders) can easily be used.
> 
> This mostly reorganizes some existing logic, with two minor changes
> in behavior:
> 
>  - The PSR registers are used instead of the previous "gpio_mask"
> values, matching AT91 behavior and removing some duplication between
> that role and that of "pinmux_mask".
> 
>  - NR_IRQs grew to acommodate a bank of external GPIOs.  Eventually
> this number should probably become a board-specific config option.
> 
> There's a debugfs dump of status for the built-in GPIOs, showing which
> pins have deglitching, pullups, or open drain drive enabled, as well
> as the ID string used when requesting each IRQ.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>

Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

I'm not going to merge it since the rest of gpiolib isn't in mainline
yet.

Haavard
