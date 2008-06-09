Return-Path: <linux-kernel-owner+w=401wt.eu-S1760973AbYFIVY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973AbYFIVY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbYFIVYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:24:05 -0400
Received: from tim.rpsys.net ([194.106.48.114]:60841 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695AbYFIVYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:24:01 -0400
X-Greylist: delayed 1456 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2008 17:23:56 EDT
Subject: Re: [patch 4/5] sparse: leds-h1940.c: make non-exported symbols
	static
From: Richard Purdie <rpurdie@rpsys.net>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Arnaud Patard <arnaud.patard@rtp-net.org>
In-Reply-To: <20080607153712.202340716@fluff.org.uk>
References: <20080607153655.026170849@fluff.org.uk>
	 <20080607153712.202340716@fluff.org.uk>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 22:02:47 +0100
Message-Id: <1213045367.5026.66.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-07 at 16:36 +0100, Ben Dooks wrote:
> plain text document attachment (sparse-fix-h1940-leds.patch)
> We do not need to export any of the routines inside
> drivers/leds/leds-h1940.c, so make them all static to
> quieten the sparse output for this driver.
> 
> Fixes the following sparse errors:
> drivers/leds/leds-h1940.c:26:6: warning: symbol 'h1940_greenled_set' was not declared. Should it be static?
> drivers/leds/leds-h1940.c:55:6: warning: symbol 'h1940_redled_set' was not declared. Should it be static?
> drivers/leds/leds-h1940.c:85:6: warning: symbol 'h1940_blueled_set' was not declared. Should it be static?
> 
> CC: Richard Purdie <rpurdie@rpsys.net>
> CC: Linux Kernel <linux-kernel@vger.kernel.org>
> CC: Arnaud Patard <arnaud.patard@rtp-net.org>
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Queued in the LEDs tree, thanks.

Richard

