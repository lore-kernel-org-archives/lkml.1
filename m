Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460Ab0ANNIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab0ANNIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 08:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232Ab0ANNIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 08:08:15 -0500
Received: from smtp.nokia.com ([192.100.122.233]:37563 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab0ANNIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 08:08:15 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 0/3] Bunch of fixes related to custom atoi() implementation
Date: Thu, 14 Jan 2010 15:07:20 +0200
Message-Id: <cover.1263473812.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 14 Jan 2010 13:08:01.0163 (UTC) FILETIME=[9991ADB0:01CA951A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

There are few fixes that substitute custom implementation of atoi() by
simple_strtol() kernel's method.

Andy Shevchenko (3):
  Fix minor spelling error in comments
  drm: Don't use own implementation of atoi()
  staging: don't use custom implementation of atoi()

 arch/x86/mm/gup.c                       |    2 +-
 drivers/gpu/drm/drm_fb_helper.c         |   24 ++--------
 drivers/staging/wlags49_h2/wl_main.c    |    2 +-
 drivers/staging/wlags49_h2/wl_profile.c |   76 +++++++++++++++---------------
 drivers/staging/wlags49_h2/wl_util.c    |   49 --------------------
 drivers/staging/wlags49_h2/wl_util.h    |    2 -
 6 files changed, 45 insertions(+), 110 deletions(-)

