Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbZFILbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbZFILbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbZFILbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:31:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47328
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbZFILbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:31:36 -0400
Date: Tue, 09 Jun 2009 04:31:38 -0700 (PDT)
Message-Id: <20090609.043138.236579164.davem@davemloft.net>
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


These two are crashers and well isolated, so I'm sending these
now.

Please pull, thanks a lot!

The following changes since commit 3af968e066d593bc4dacc021715f3e95ddf0996f:
  Linus Torvalds (1):
        async: Fix lack of boot-time console due to insufficient synchronization

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Eric Dumazet (1):
      r8169: fix crash when large packets are received

Minoru Usui (1):
      cls_cgroup: Fix oops when user send improperly 'tc filter add' request

 drivers/net/r8169.c    |   11 +++++------
 net/sched/cls_cgroup.c |    3 +++
 2 files changed, 8 insertions(+), 6 deletions(-)
