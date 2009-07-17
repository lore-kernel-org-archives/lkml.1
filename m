Return-Path: <linux-kernel-owner+w=401wt.eu-S934620AbZGQNbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934620AbZGQNbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934612AbZGQNbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:31:36 -0400
Received: from ozlabs.org ([203.10.76.45]:60569 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934509AbZGQNbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:31:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest & virtio fixes
Date: Fri, 17 Jul 2009 23:01:17 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Mark McLoughlin <markmc@redhat.com>,
       Alex Williamson <alex.williamson@hp.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Christoph Hellwig <hch@lst.de>,
       Matias Zabaljauregui <zabaljauregui@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907172301.17896.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4b0a84043e0c14088958fddb62f416d050368011:                             
  Linus Torvalds (1):                                                                                    
        Merge branch 'sched-fixes-for-linus' of git://git.kernel.org/.../peterz/linux-2.6-sched          

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Alex Williamson (1):
      virtio_net: Sync header with qemu

Christoph Hellwig (2):
      virtio_blk: don't bounce highmem requests
      virtio_blk: ioctl return value fix

Davide Libenzi (1):
      lguest: remove unnecessary forward struct declaration

Mark McLoughlin (1):
      virtio-pci: correctly unregister root device on error

Matias Zabaljauregui (1):
      lguest: fix journey

Rusty Russell (1):
      lguest: restrict CPUID to avoid perf counter wrmsr

 arch/x86/include/asm/lguest_hcall.h |    2 +-
 arch/x86/lguest/boot.c              |    7 ++++++-
 drivers/block/virtio_blk.c          |    5 ++++-
 drivers/lguest/lg.h                 |    2 --
 drivers/virtio/virtio_pci.c         |    2 +-
 include/linux/lguest.h              |    2 +-
 include/linux/virtio_net.h          |   14 ++++++++++----
 7 files changed, 23 insertions(+), 11 deletions(-)

