Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbYG1Owi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbYG1Owi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYG1Owa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:52:30 -0400
Received: from styx.suse.cz ([82.119.242.94]:42417 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750851AbYG1Owa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:52:30 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [RESEND][PATCH 00/12] ipwireless: driver updates
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
       dsterba@suse.cz
Date: Mon, 28 Jul 2008 16:52:27 +0200
Message-ID: <20080728145124.13378.39300.stgit@ds.suse.cz>
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

