Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbZBCAH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbZBCAH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbZBCAHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:07:09 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:44805 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017AbZBCAHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:07:06 -0500
X-Trace: 141784666/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.198/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.198
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMFAHMZh0lQLLDG/2dsb2JhbACBbcshhBQG
X-IronPort-AV: E=Sophos;i="4.37,368,1231113600"; 
   d="scan'208";a="141784666"
Subject: [PATCH] sh: maple: Add support for VMU devices (v2) [0/3]
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: greg KH <greg@kroah.com>, Paul Mundt <lethal@linux-sh.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 00:06:09 +0000
Message-Id: <1233619569.13918.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches adds support for the Dreamcast Visual Memory
Unit, reworking the maple bus code to ensure it supports asynchronous
reads and writes. A consequential amendment to the keyboard driver is
also included.

The VMU is a 'smart' flash chip where access is controlled by a
microcontroller so that, for instance, flash erases appear to be
transparent to the end user. The VMU does, however, show typical
flash-type behaviour (eg phased writes) and the MTD layer and the chip
work well together (eg in the way they handle apparent hotplug events
during a block write).

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

