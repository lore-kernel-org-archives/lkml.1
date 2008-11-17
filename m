Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYKQHwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYKQHwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYKQHvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:51:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34235
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752184AbYKQHvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:51:53 -0500
Date: Sun, 16 Nov 2008 23:51:53 -0800 (PST)
Message-Id: <20081116.235153.246607423.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Highlights include a fix for a long standing sparc build warning
and dev_name() usage in sparc specific device layers (hopefully
this one doesn't introduce the kinds of bugs the ACPI case seems
to have :-)

Please pull, thanks a lot!

The following changes since commit 12de512ae1d6d150f95b7157cb3293ef7545676d:
  David S. Miller (1):
        sparc64: Update defconfig.

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Alessandro Zummo (1):
      rtc: rtc-sun4v fixes, revised

Kay Sievers (1):
      sparc: struct device - replace bus_id with dev_name(), dev_set_name()

Robert Reif (1):
      sparc: Fix tty compile warnings.

 arch/sparc/include/asm/termbits.h |   11 +++---
 arch/sparc/kernel/of_device.c     |    4 +-
 drivers/rtc/rtc-sun4v.c           |   69 ++++++++++--------------------------
 3 files changed, 26 insertions(+), 58 deletions(-)
