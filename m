Return-Path: <linux-kernel-owner+w=401wt.eu-S1751238AbZKIFbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbZKIFbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 00:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbZKIFbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 00:31:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34338
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbZKIFbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 00:31:12 -0500
Date: Sun, 08 Nov 2009 21:31:38 -0800 (PST)
Message-Id: <20091108.213138.205827243.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix a locking bug pointed out by Thomas Gleixner and clarify some
aspects of our sparc64 barriers.

Please pull, thanks a lot.

The following changes since commit 2e2ec952350f25242f2e0539db16b1e46f9eb01b:
  Linus Torvalds (1):
        Merge branch 'bugfix' of git://git.kernel.org/.../jeremy/xen

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (2):
      sparc64: Add a comment about why we only use certain memory barriers these days.
      sparc: Move of_set_property_mutex acquisition outside of devtree_lock grab.

Roel Kluin (1):
      sparc64: replace parentheses in pmul()

 arch/sparc/include/asm/system_64.h |    4 ++++
 arch/sparc/kernel/prom_common.c    |    4 ++--
 arch/sparc/kernel/visemul.c        |    2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)
