Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYLBHUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYLBHUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 02:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYLBHTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 02:19:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45983
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752801AbYLBHTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 02:19:34 -0500
Date: Mon, 01 Dec 2008 23:19:35 -0800 (PST)
Message-Id: <20081201.231935.211354491.davem@davemloft.net>
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


Two bug sets of fixes:

1) Several starfire rtc driver bug fixes from Allesandro Zummo.

2) The calculation of the fault fixup offset on sparc64 is upside
   down.

Please pull, thanks a lot!

The following changes since commit cecf61bdee426a3e0a014f7e26990d09c71ed458:
  Alessandro Zummo (1):
        rtc: rtc-sun4v fixes, revised

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Alessandro Zummo (1):
      rtc: rtc-starfire fixes

David S. Miller (1):
      sparc64: Fix offset calculation in compute_size()

 arch/sparc64/lib/user_fixup.c |    2 +-
 drivers/rtc/rtc-starfire.c    |   66 ++++++++---------------------------------
 2 files changed, 14 insertions(+), 54 deletions(-)
