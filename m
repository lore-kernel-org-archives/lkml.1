Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZK3JRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZK3JRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbZK3JRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:17:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48609
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964AbZK3JRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:17:22 -0500
Date: Mon, 30 Nov 2009 01:17:28 -0800 (PST)
Message-Id: <20091130.011728.178511140.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix regression in ATA_CMD_SET_FEATURES IDE ioctls done on UDMA modes,
the code accidently was changed to use a fixed XFER_UDMA_6 when it
should instead use the given tf->nsect value.

Please pull, thanks a lot!

The following changes since commit a8a8a669ea13d792296737505adc43ccacf3a648:
  Linus Torvalds (1):
        Merge branch 'i2c-pnx-fixes' of git://git.fluff.org/bjdooks/linux

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

Hemant Pedanekar (1):
      ide: fix ioctl to pass requested transfer mode to ide_find_dma_mode instead of UDMA6

 drivers/ide/ide-ioctls.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
