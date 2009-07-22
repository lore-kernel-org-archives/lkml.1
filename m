Return-Path: <linux-kernel-owner+w=401wt.eu-S1751695AbZGVEWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbZGVEWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 00:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZGVEVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 00:21:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39483
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816AbZGVEVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 00:21:47 -0400
Date: Tue, 21 Jul 2009 21:21:52 -0700 (PDT)
Message-Id: <20090721.212152.43170346.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) When FS delivers flush commands to an IDE disk (as XFS does, for
   example) we leak memory.  Fix from Maxime Bizon.

2) IDE tape can leak kstack to userspace, fix from Michael Buesch.

Please pull, thanks a lot!

The following changes since commit aea1f7964ae6cba5eb419a958956deb9016b3341:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../sam/kbuild-fixes

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

Maxime Bizon (1):
      ide: fix memory leak when flush command is issued

Michael Buesch (1):
      ide-tape: Don't leak kernel stack information

 drivers/ide/ide-disk.c |    1 +
 drivers/ide/ide-tape.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)
