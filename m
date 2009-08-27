Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZH0Dtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZH0Dtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZH0Dtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:49:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40697
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703AbZH0Dtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:49:52 -0400
Date: Wed, 26 Aug 2009 20:50:05 -0700 (PDT)
Message-Id: <20090826.205005.08658813.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two fixes:

1) Fix smc91x build on SMP, from Alexey Dobriyan

2) Handle out-of-memory situations more correctly when trying
   to refill the RX ring buffers in virtio_net driver.  From Rusty
   Russell.  Based upon user reports.

Please pull, thanks a lot!

The following changes since commit f415c413f458837bd0c27086b79aca889f9435e4:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Alexey Dobriyan (1):
      smc91x: fix compilation on SMP

Rusty Russell (1):
      virtio: net refill on out-of-memory

 drivers/net/smc91x.c     |    2 +-
 drivers/net/virtio_net.c |   61 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 47 insertions(+), 16 deletions(-)
