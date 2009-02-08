Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZBHTxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZBHTxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 14:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZBHTxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 14:53:03 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:62811 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992AbZBHTxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 14:53:00 -0500
X-Trace: 142066980/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.198/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.198
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoEAH3GjklQLLDG/2dsb2JhbACBbspshBoG
X-IronPort-AV: E=Sophos;i="4.37,400,1231113600"; 
   d="scan'208";a="142066980"
Subject: Re: [PATCH] sh: maple: add support for Visual Memory Card devices,
 and make consequential changes to maple input drivers - 0/3 - v5 - diff
 stat correction
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       dwmw2 <dwmw2@infradead.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>
In-Reply-To: <1234122069.6736.8.camel@localhost.localdomain>
References: <1234122069.6736.8.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 08 Feb 2009 19:52:17 +0000
Message-Id: <1234122737.6736.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Great start... sorry here is correct diff stat for these patches...

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---
 
 drivers/input/joystick/maplecontrol.c |    4 +-
 drivers/input/keyboard/maple_keyb.c   |   37 +-
 drivers/mtd/maps/Kconfig              |   12 +-
 drivers/mtd/maps/Makefile             |    1 +
 drivers/mtd/maps/vmu-flash.c          |  827 +++++++++++++++++++++++++++++++++
 drivers/sh/maple/maple.c              |  463 ++++++++++---------
 include/linux/maple.h                 |   62 ++-
 7 files changed, 1139 insertions(+), 267 deletions(-)

