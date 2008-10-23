Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbYJWQaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbYJWQaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYJWQan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:30:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44157 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752889AbYJWQam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:30:42 -0400
Date: Thu, 23 Oct 2008 11:30:41 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH 0/2 v2] SGI RTC: add clocksource/clockevent driver
Message-ID: <20081023163041.GA14574@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches provide a driver for synchronized RTC clocksource and
clockevents for SGI systems.

With these patches, a module can be installed that registers the system-wide
synchronized RTC clocksource and timers as both a clocksource and clockevents
device running in high resolution mode.


[PATCH 1/2 v2] SGI RTC: add clocksource driver
[PATCH 2/2 v2] SGI RTC: add RTC system interrupt
