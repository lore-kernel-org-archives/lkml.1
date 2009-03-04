Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZCDSy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZCDSy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755696AbZCDSyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:54:19 -0500
Received: from relay2.sgi.com ([192.48.179.30]:50861 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755656AbZCDSyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:54:18 -0500
Date: Wed, 4 Mar 2009 12:54:13 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3 v7] SGI RTC: add UV RTC clocksource/clockevents and
	generic system vector
Message-ID: <20090304185413.GA24385@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches provide UV RTC driven clocksource and clockevents for SGI systems, as well as introducing a generic system interrupt vector.

With these patches, the UV system-wide synchronized RTC clock and timers are used as clocksource and clockevents running in high resolution mode.


Subject: [PATCH 1/3 v7] SGI RTC: add generic system vector
Subject: [PATCH 2/3 v7] SGI RTC: loop through installed UV blades
Subject: [PATCH 3/3 v7] SGI RTC: add UV RTC clocksource/clockevents
