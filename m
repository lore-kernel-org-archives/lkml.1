Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZDFWQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZDFWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759129AbZDFWQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:16:36 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38501 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759043AbZDFWQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:16:35 -0400
Date: Mon, 6 Apr 2009 15:16:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       niv@us.ibm.com, manfred@colorfullife.com, peterz@infradead.org,
       lethal@linux-sh.org, kernel@wantstofly.org, andi@firstfloor.org,
       kyle@mcmartin.ca, deller@gmx.de, davem@davemloft.net,
       ralf@linux-mips.org, jes@sgi.com, benh@kernel.crashing.org,
       paulus@samba.org, anton@samba.org
Subject: [PATCH -tip] v2: Make TREE_RCU be default (was CLASSIC_RCU).
Message-ID: <20090406221628.GA18232@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that there have been no TREE_RCU bugs reported for some months,
it is time to make TREE_RCU be the default RCU implementation.  The rest
of this series updates defconfig files that: (1) have CONFIG_SMP=y and
(2) explicitly mention CONFIG_CLASSIC_RCU.

Given that I don't have access to most of the relevant hardware, much
of this is untested.

Changes since v1: per-arch defconfig patches dropped.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 236a793..ef9d030 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -302,7 +302,7 @@ menu "RCU Subsystem"

 choice
 	prompt "RCU Implementation"
-	default CLASSIC_RCU
+	default TREE_RCU

 config CLASSIC_RCU
 	bool "Classic RCU"
-- 
1.5.2.5


