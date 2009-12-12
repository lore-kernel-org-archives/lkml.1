Return-Path: <linux-kernel-owner+w=401wt.eu-S1762089AbZLLL3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762089AbZLLL3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 06:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761966AbZLLL3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 06:29:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34332
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762027AbZLLL3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 06:29:31 -0500
Date: Sat, 12 Dec 2009 03:29:38 -0800 (PST)
Message-Id: <20091212.032938.136002802.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm doing a quick push to fix the Kaweth USB driver build
failure.  It's due to a miscommunication between Greg KH
and myself, and we'll make sure this doesn't happen again.

There's also two Intel gigabit fixes from Alexander Duyck and
a be2net driver fix from Ajit Khaparde.

Please pull, thanks a lot!

The following changes since commit 053fe57ac249a9531c396175778160d9e9509399:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Ajit Khaparde (1):
      be2net: fix error in rx completion processing.

Alexander Duyck (2):
      igb: fix handling of mailbox collisions between PF/VF
      igbvf: avoid reset storms due to mailbox issues

Oliver Neukum (1):
      usb: remove rare pm primitive for conversion to new API

 drivers/net/benet/be_main.c |    4 ++--
 drivers/net/igb/igb_main.c  |   22 +++++++++++++---------
 drivers/net/igbvf/igbvf.h   |    1 +
 drivers/net/igbvf/netdev.c  |    8 +++++++-
 drivers/net/usb/kaweth.c    |    4 ++--
 5 files changed, 25 insertions(+), 14 deletions(-)
