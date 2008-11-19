Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYKSVWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYKSVWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYKSVWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:22:06 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35250 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753187AbYKSVWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:22:03 -0500
Date: Wed, 19 Nov 2008 15:22:02 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/2 v3] SGI RTC: add clocksource/clockevent driver and generic timer vector
Message-ID: <20081119212202.GA3377@sgi.com>
References: <20081023163041.GA14574@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023163041.GA14574@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches provide a driver for synchronized RTC clocksource and
clockevents for SGI systems, as well as a generic timer system interrupt.

With these patches, a module can be installed that registers the system-wide
synchronized RTC clocksource and timers as both a clocksource and clockevents
device running in high resolution mode.


[PATCH 1/2 v3] SGI RTC: add clocksource driver
[PATCH 2/2 v3] SGI RTC: add generic timer system interrupt

