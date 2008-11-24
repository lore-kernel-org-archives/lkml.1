Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYKXUBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYKXUBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbYKXUBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:01:03 -0500
Received: from relay3.sgi.com ([192.48.171.31]:59471 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752205AbYKXUBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:01:03 -0500
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2008 15:01:03 EST
Date: Mon, 24 Nov 2008 13:54:05 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, john stultz <johnstul@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/2 v4] SGI RTC: add clocksource/clockevent driver and generic timer vector
Message-ID: <20081124195405.GA8339@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches provide a driver for synchronized RTC clocksource and
clockevents for SGI systems, as well as a generic timer system interrupt.

With these patches, a module can be installed that registers the system-wide
synchronized RTC clocksource and timers as both a clocksource and clockevents
device running in high resolution mode.


[PATCH 1/2 v4] SGI RTC: add generic timer system interrupt
[PATCH 2/2 v4] SGI RTC: add clocksource driver
