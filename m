Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYJWVpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYJWVpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYJWVpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:45:10 -0400
Received: from mga12.intel.com ([143.182.124.36]:18656 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752030AbYJWVpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:45:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,472,1220252400"; 
   d="scan'208";a="64583789"
Subject: [GIT PULL] Backlight updates for 2.6.28
From: Richard Purdie <rpurdie@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 22:44:59 +0100
Message-Id: <1224798299.5427.75.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-backlight for-linus

for the backlight tree updates for 2.6.28. These are all new drivers and
have seen testing in -mm/-next.

Thanks, Richard

 arch/arm/mach-pxa/include/mach/tosa.h |    3 
 arch/arm/mach-pxa/tosa.c              |   21 ++
 drivers/video/backlight/Kconfig       |   32 +++
 drivers/video/backlight/Makefile      |    4 
 drivers/video/backlight/da903x.c      |  201 ++++++++++++++++++++++++
 drivers/video/backlight/kb3886_bl.c   |  204 ++++++++++++++++++++++++
 drivers/video/backlight/tosa_bl.c     |  198 ++++++++++++++++++++++++
 drivers/video/backlight/tosa_lcd.c    |  280 ++++++++++++++++++++++++++++++++++
 8 files changed, 942 insertions(+), 1 deletion(-)

Claudio Nieder (1):
      backlight: Add driver for Tabletkiosk Sahara TouchIT-213 Tablet PC

Dmitry Baryshkov (2):
      backlight: add support for Sharp SL-6000 LCD and backlight drivers
      tosa: add support for bl/lcd driver

Mike Rapoport (1):
      backlight: da903x: Add backlight driver for DA9030/DA9034


