Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbYGTXXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbYGTXXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 19:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYGTXXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 19:23:06 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:44208 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbYGTXXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 19:23:04 -0400
Date: Mon, 21 Jul 2008 01:24:43 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Philipp Zabel <philipp.zabel@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT] MFD pull request
Message-ID: <20080720232442.GA2574@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the mfd (multifunction devices) merge request for 2.6.27.
The 12 patches are mostly asic3 ones.

Some more mfd patches should also be merged through Russell King's
ARM tree, as they've been sitting there before I opened my mfd git tree.


The following changes since commit 5b664cb235e97afbf34db9c4d77f08ebd725335e:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../mfasheh/ocfs2

are available in the git repository at:

  git://git.o-hand.com/linux-mfd for-linus

Philipp Zabel (6):
      mfd: move asic3 probe functions into __init section
      mfd: fix asic3 config array initialisation
      mfd: fix the asic3 irq demux code
      mfd: add ASIC3_CONFIG_GPIO templates
      mfd: remove DS1WM register definitions from asic3.h
      mfd: let asic3 use mem resource instead of bus_shift

Samuel Ortiz (6):
      mfd: asic3 gpiolib support
      mfd: asic3 children platform data removal
      mfd: New asic3 gpio configuration code
      mfd: use dev_* macros for asic3 debugging
      mfd: Use uppercase only for asic3 macros and defines
      mfd: asic3 should depend on gpiolib

 drivers/mfd/Kconfig       |    2 +-
 drivers/mfd/asic3.c       |  388 ++++++++++++++++++++++++++-------------------
 include/linux/mfd/asic3.h |  185 +++++++++++-----------
 3 files changed, 319 insertions(+), 256 deletions(-)
