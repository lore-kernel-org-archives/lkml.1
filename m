Return-Path: <linux-kernel-owner+w=401wt.eu-S1759062AbYBNPmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062AbYBNPmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbYBNPjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:39:14 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:49908 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753016AbYBNPjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:39:11 -0500
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Subject: Use time_* macros
Date: Thu, 14 Feb 2008 17:36:38 +0200
Message-Id: <1203003412-11594-1-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: y
References: y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.

So following patchset implements usage of the time_* macros, defined at linux/jiffies.h, which deals with wrapping correctly

 arch/alpha/kernel/traps.c            |    3 ++-
 arch/ia64/kernel/irq_ia64.c          |    2 +-
 arch/ia64/kernel/mca.c               |    3 ++-
 arch/ia64/kernel/unaligned.c         |    3 ++-
 arch/parisc/kernel/unaligned.c       |    2 +-
 arch/powerpc/platforms/iseries/pci.c |    3 ++-
 arch/sparc64/kernel/unaligned.c      |    3 ++-
 drivers/net/arcnet/arcnet.c          |    4 ++--
 drivers/net/ax88796.c                |    5 +++--
 drivers/net/tokenring/3c359.c        |   21 +++++++++++----------
 drivers/net/wireless/atmel.c         |    5 +++--
 fs/binfmt_aout.c                     |    7 ++++---
 include/linux/arcdevice.h            |    2 +-
 kernel/irq/spurious.c                |    3 ++-
 mm/page_alloc.c                      |    3 ++-
 mm/pdflush.c                         |    5 +++--
 net/bluetooth/hci_core.c             |    5 +++--
 net/mac80211/rc80211_simple.c        |    3 ++-
 net/mac80211/rx.c                    |    3 ++-
 19 files changed, 50 insertions(+), 35 deletions(-)

