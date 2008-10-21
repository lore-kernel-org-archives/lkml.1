Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbYJUVRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbYJUVRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYJUVRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:17:43 -0400
Received: from relay2.sgi.com ([192.48.171.30]:57819 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751507AbYJUVRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:17:42 -0400
Date: Tue, 21 Oct 2008 16:17:40 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Cc: Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH 0/3] SGI RTC: add clocksource/clockevent driver and timer bios calls
Message-ID: <20081021211740.GA3936@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset provides a driver and bios call framework for
synchronized RTC clocksource and clockevents for SGI systems.

With these patches, a module can be installed that registers the system-wide
synchronized RTC clocksource and timers as both a clocksource and clockevents
device running in high resolution mode.


[PATCH 1/3] SGI RTC: add clocksource driver
[PATCH 2/3] SGI RTC: add bios framework for RTC timer operations
[PATCH 3/3] SGI RTC: add RTC system interrupt

These patches should be installed on top of the following:
	http://marc.info/?l=linux-kernel&m=122461934110503&w=2
	http://marc.info/?l=linux-kernel&m=122461934110506&w=2
	http://marc.info/?l=linux-kernel&m=122461934210509&w=2
