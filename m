Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0CNCRf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 21:17:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53241
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752743Ab0CNCRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 21:17:33 -0500
Date: Sat, 13 Mar 2010 18:17:54 -0800 (PST)
Message-Id: <20100313.181754.107699673.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A framebuffer driver for XVR-1000 cards and a fixup for the string
used in a request_irq() call in a sparc qlogicpti scsi driver (it
contained a "/" character so procfs rightly complains).

Please pull, thanks a lot!

The following changes since commit d89b218b801fd93ea95880f1c7fde348cbcc51c5:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Add very basic XVR-1000 framebuffer driver.

Meelis Roos (1):
      qlogicpti: Remove slash in QlogicPTI irq name

 drivers/scsi/qlogicpti.c   |    2 +-
 drivers/video/Kconfig      |   12 +++
 drivers/video/Makefile     |    1 +
 drivers/video/sunxvr1000.c |  228 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 242 insertions(+), 1 deletions(-)
 create mode 100644 drivers/video/sunxvr1000.c
