Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYKKGXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYKKGXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbYKKGXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:23:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56482
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751949AbYKKGXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:23:00 -0500
Date: Mon, 10 Nov 2008 22:23:00 -0800 (PST)
Message-Id: <20081110.222300.37708978.davem@davemloft.net>
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


A revert to fix a 32-bit sparc bootup regression, and a defconfig
update for sparc64.

Please pull, thanks a lot.

The following changes since commit 3ad4f597058301c97f362e500a32f63f5c950a45:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../tiwai/sound-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (2):
      Revert "sparc: correct section of current_pc()"
      sparc64: Update defconfig.

 arch/sparc/kernel/head.S |    1 -
 arch/sparc64/defconfig   |  232 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 195 insertions(+), 38 deletions(-)
