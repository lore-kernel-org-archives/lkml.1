Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbZJUUVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbZJUUVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZJUUVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:21:23 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:13100 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbZJUUVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:21:22 -0400
Date: Thu, 22 Oct 2009 01:21:21 +0500
From: Constantin Baranov <const@mimas.ru>
To: Daniel Mack <daniel@caiaq.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] leds-alix2: add support for button connected to J15
Message-Id: <20091022012121.5b35ff22.const@mimas.ru>
In-Reply-To: <20091021193347.GL14091@buzzloop.caiaq.de>
References: <20091016130315.GT28832@buzzloop.caiaq.de>
	<20091018072738.GF3935@core.coreip.homeip.net>
	<20091019073728.GC28832@buzzloop.caiaq.de>
	<20091020013852.GC24370@core.coreip.homeip.net>
	<20091020101357.GR28832@buzzloop.caiaq.de>
	<20091021043553.GA378@core.coreip.homeip.net>
	<20091021193347.GL14091@buzzloop.caiaq.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Daniel!

I wonder why do you integrate the input driver into the leds driver. They
should be separated. Or at least the complex driver should be moved to the
"X86 Platform Specific Device Drivers" and renamed to some like "PC Engines
ALIX Extras". I personally would prefer the separation way.

Also ALIX.2 documentation describes the "Mode switch" driven by GPIO which is a
small button on front side of a board. I guessed your driver is not for this
button. If so, would it be better to provide the mode switch as KEY_PROG1 and
the J15 connected button as KEY_PROG2 at once?

Cheers,
Constantin

> From 66953e5dda7bbbc22b92541ed3a6020773c62140 Mon Sep 17 00:00:00 2001
> From: Daniel Mack <daniel@caiaq.de>
> Date: Tue, 13 Oct 2009 12:42:52 +0800
> Subject: [PATCH] leds-alix2: add support for button connected to J15
> 
> The ALIX2 boards have one GPIO pin which is reachable at connector J15.
> One possible application for this feature is to connect a button which
> closes the two pins.
> 
> This patch adds support to query these button and export its state via
> an input device.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: linux-input@vger.kernel.org
> Cc: Constantin Baranov <const@mimas.ru>
