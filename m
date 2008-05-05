Return-Path: <linux-kernel-owner+w=401wt.eu-S1763535AbYEEWo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763535AbYEEWo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763338AbYEEWko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:40:44 -0400
Received: from ozlabs.org ([203.10.76.45]:53387 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763317AbYEEWkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:40:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18463.35871.690630.904570@cargo.ozlabs.ibm.com>
Date: Tue, 6 May 2008 08:37:19 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git powerpc-next branch
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's try this again...

Linus,

Please pull from 'powerpc-next' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git powerpc-next

There are five commits there that Andrew Morton has sent on to
me: three semaphore to mutex conversions, one that changes a
proc_create call to proc_create_data, and one that adds a new
devm_ioremap_prot function and makes devm_ioremap_release (in
lib/devres.c) available to outside callers.

If you think these should wait until 2.6.27, that's OK, just let me
know.  I think they are safe to go in 2.6.26.

Thanks,
Paul.

 arch/powerpc/lib/Makefile                |    1 +
 arch/powerpc/lib/devres.c                |   42 ++++++++++++++++++++++++++++++
 arch/powerpc/platforms/pseries/scanlog.c |   19 +-------------
 drivers/macintosh/adb.c                  |   30 +++++++++++----------
 drivers/macintosh/therm_pm72.c           |   31 +++++++++++-----------
 drivers/macintosh/windfarm_smu_sat.c     |   10 ++++---
 include/asm-powerpc/io.h                 |    8 +++++-
 include/linux/io.h                       |    1 +
 lib/devres.c                             |    2 +
 9 files changed, 90 insertions(+), 54 deletions(-)
 create mode 100644 arch/powerpc/lib/devres.c

Daniel Walker (3):
      [POWERPC] macintosh: therm_pm72: driver_lock semaphore to mutex
      [POWERPC] macintosh: windfarm_smu_sat: semaphore to mutex
      [POWERPC] macintosh: ADB driver: adb_handler_sem semaphore to mutex

Denis V. Lunev (1):
      [POWERPC] Assign PDE->data before gluing PDE into /proc tree

Emil Medve (1):
      [POWERPC] devres: Add devm_ioremap_prot()

