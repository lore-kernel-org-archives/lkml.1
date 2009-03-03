Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZCCPK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZCCPK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbZCCPKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:10:51 -0500
Received: from relay2.sgi.com ([192.48.179.30]:41508 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753292AbZCCPKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:10:50 -0500
Date: Tue, 3 Mar 2009 09:10:44 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6 v6] SGI RTC: add clocksource/clockevent driver and
	generic vector
Message-ID: <20090303151044.GA20016@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches provide a driver for synchronized RTC clocksource and
clockevents for SGI systems, as well as a generic system interrupt.

With these patches, a module can be installed that registers the system-wide
synchronized RTC clocksource and timers as both a clocksource and clockevents
device running in high resolution mode.


Subject: [PATCH 1/6 v6] SGI RTC: add generic system interrupt
Subject: [PATCH 2/6 v6] SGI RTC: export clocksource_unregister
Subject: [PATCH 3/6 v6] SGI RTC: export clockevents_register_device
Subject: [PATCH 4/6 v6] SGI RTC: export schedule_on_each_cpu
Subject: [PATCH 5/6 v6] SGI RTC: loop through installed UV blades
Subject: [PATCH 6/6 v6] SGI RTC: add clocksource driver

