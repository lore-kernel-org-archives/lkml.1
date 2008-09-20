Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYITSFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYITSFW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 14:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYITSFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 14:05:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:49500 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYITSFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 14:05:08 -0400
Date: Sat, 20 Sep 2008 11:05:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@elte.hu
Subject: Whats in kerneloops.git for 2.6.28
Message-ID: <20080920110509.0cae9c08@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kerneloops.git tree is a (small) tree that contains patches that help
kerneloops.org give better results by improving the diagnostics output
of the Linux kernel.


Updating linus
The following changes since commit 9824b8f11373b0df806c135a342da9319ef1d893:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git390.osdl.marist.edu/pub/scm/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-kerneloops.git master

Arjan van de Ven (5):
      procfs: use WARN() rather than printk+backtrace
      fs: add a sanity check in d_free
      debug: Introduce a dev_WARN() function
      debug: use dev_WARN() rather than WARN_ON() in device_pm_add()
      usb: turn dev_warn+WARN_ON combos into dev_WARN

 drivers/base/power/main.c |    2 +-
 drivers/usb/host/uhci-q.c |   24 ++++++++----------------
 fs/dcache.c               |    1 +
 fs/proc/generic.c         |    3 +--
 include/linux/device.h    |    8 ++++++++
 5 files changed, 19 insertions(+), 19 deletions(-)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
