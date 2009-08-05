Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZHEPhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZHEPhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbZHEPhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:37:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39331
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867AbZHEPhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:37:07 -0400
Date: Wed, 05 Aug 2009 08:37:16 -0700 (PDT)
Message-Id: <20090805.083716.239931149.davem@davemloft.net>
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


Ingo found and fixed a lockdep regression added in yesterday's
networking fixes that several people are hitting now.

Please pull, thanks a lot!

The following changes since commit 90bc1a658a53f8832ee799685703977a450e5af9:
  Linus Torvalds (1):
        Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Ingo Molnar (1):
      net: Fix spinlock use in alloc_netdev_mq()

 net/core/dev.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
