Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZIDM1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZIDM1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 08:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbZIDM1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 08:27:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32992
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755862AbZIDM1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 08:27:20 -0400
Date: Fri, 04 Sep 2009 05:27:35 -0700 (PDT)
Message-Id: <20090904.052735.120899977.davem@davemloft.net>
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


Please pull to get these two sparc bug fixes.

Thanks!

The following changes since commit 37d0892c5a94e208cf863e3b7bac014edee4346d:
  Ian Kent (1):
        autofs4 - fix missed case when changing to use struct path

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (2):
      sparc64: Kill spurious NMI watchdog triggers by increasing limit to 30 seconds.
      sparc64: Fix bootup with mcount in some configs.

 arch/sparc/kernel/irq_64.c |    2 +-
 arch/sparc/kernel/nmi.c    |    2 +-
 arch/sparc/prom/misc_64.c  |    2 +-
 arch/sparc/prom/printf.c   |    7 +++----
 4 files changed, 6 insertions(+), 7 deletions(-)
