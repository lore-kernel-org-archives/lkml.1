Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZLNASa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZLNASa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbZLNASY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:18:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34187 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbZLMX5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:49 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, netdev@vger.kernel.org,
       torvalds@linux-foundation.org, davem@davemloft.net
Subject: [PATCH 0/3] constify various _ops structures for net-next-dave-git-a252e7
Date: Mon, 14 Dec 2009 00:59:39 +0100
Message-Id: <cover.1260707013.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Hello everyone!

The following patch series attempts to constify several structures
that hold function pointers. This is only the initial batch, there
are other candidate structures, some of which can probably be
constified as well, I plan to submit them in the future.

The list of constified structures in this series:
e1000_mac_operations
e1000_phy_operations
e1000_nvm_operations

There are certain exceptions where a given instance of the structure
cannot be const, they are marked with a comment in the patch.

The patches compile fine with an allyesconfig kernel on i386 and x86_64.

Please let me know if any of these structures should not be constified
and any other issues you see with them.


Changelog:
----------
v1 -> v2
	- updated to net-next-dave-git-a252e7
	- extended comments with a reference to code that prevents constification

Thanks,
   Emese

 drivers/net/e1000e/82571.c    |   11 ++++++-----
 drivers/net/e1000e/e1000.h    |    6 +++---
 drivers/net/e1000e/es2lan.c   |    7 ++++---
 drivers/net/e1000e/hw.h       |   18 ++++++++++--------
 drivers/net/e1000e/ich8lan.c  |    6 +++---
 drivers/net/igb/e1000_82575.c |    6 +++---
 drivers/net/igb/e1000_hw.h    |    7 +++++--
 drivers/net/igbvf/vf.h        |    1 +
 8 files changed, 35 insertions(+), 27 deletions(-)

