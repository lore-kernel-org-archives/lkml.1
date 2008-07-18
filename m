Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYGRWLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYGRWLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYGRWK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:10:56 -0400
Received: from styx.suse.cz ([82.119.242.94]:55468 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752774AbYGRWKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:10:55 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 00/12] ipwireless: driver updates
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dsterba@suse.cz, jkosina@suse.cz
Date: Sat, 19 Jul 2008 00:10:54 +0200
Message-ID: <20080718220840.19195.4140.stgit@ds.suse.cz>
User-Agent: StGIT/0.14.3.173.g2e37
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

series contains code cleanups and a few improvements.
Please apply for 2.6.27.

Thanks,
David Sterba

---

David Sterba (12):
      ipwireless: Preallocate received packet buffers with MRU size
      ipwireless: Put packets to pool start
      ipwireless: Increase PPP outgoing queue size
      ipwireless: Explicitly request io and mem regions
      ipwireless: Constify buffer variables
      ipwireless: Do not return value from sending funcs
      ipwireless: Remove endian-dependent bitfields
      ipwireless: Glue splitted printk strings back
      ipwireless: Remove pt_regs from interrupt handler
      ipwireless: Rename spinlock variables to lock
      ipwireless: Remove unused defines
      ipwireless: Misc cleanups


 drivers/char/pcmcia/ipwireless/hardware.c |  275 ++++++++++++++---------------
 drivers/char/pcmcia/ipwireless/hardware.h |    4
 drivers/char/pcmcia/ipwireless/main.c     |   86 +++++----
 drivers/char/pcmcia/ipwireless/main.h     |    5 +
 drivers/char/pcmcia/ipwireless/network.c  |   58 +++---
 drivers/char/pcmcia/ipwireless/network.h  |    1
 drivers/char/pcmcia/ipwireless/tty.c      |    2
 7 files changed, 225 insertions(+), 206 deletions(-)

--

