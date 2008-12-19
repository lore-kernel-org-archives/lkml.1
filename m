Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbYLSQIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbYLSQIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYLSQHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:07:53 -0500
Received: from relay2.sgi.com ([192.48.179.30]:52840 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751056AbYLSQHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:07:52 -0500
Date: Fri, 19 Dec 2008 10:07:51 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2 v5] SGI RTC: add clocksource/clockevent driver and generic timer vector
Message-ID: <20081219160751.GA18071@sgi.com>
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


[PATCH 1/2 v5] SGI RTC: add generic timer system interrupt
[PATCH 2/2 v5] SGI RTC: add clocksource driver
