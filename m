Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYITBOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYITBOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 21:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbYITBOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 21:14:33 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:57336 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYITBOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 21:14:32 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>, Alan Cox <alan@redhat.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 0/3] omap watchdog updates
Date: Sat, 20 Sep 2008 04:14:00 +0300
Message-Id: <1221873243-18303-1-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.0.1.196.g01914
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <felipe.balbi@nokia.com>

The following patches should be "mergeable" now.

Thanks for Russel, David, Alan and all of you guys
who spent some time reviewing it.

Felipe Balbi (3):
  watchdog: sync linux-omap changes
  watchdog: another ioremap() fix
  watchdog: cleanup a bit omap_wdt.c

 arch/arm/plat-omap/devices.c |   21 ++-
 drivers/watchdog/omap_wdt.c  |  339 ++++++++++++++++++++++++++++--------------
 drivers/watchdog/omap_wdt.h  |   28 +---
 3 files changed, 247 insertions(+), 141 deletions(-)

