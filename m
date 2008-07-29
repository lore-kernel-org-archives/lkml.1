Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbYG2ADQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbYG2ADQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYG2ADA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:03:00 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:39316 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbYG2AC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:02:59 -0400
Date: Tue, 29 Jul 2008 02:02:55 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Mike Rapoport <mike@compulab.co.il>, Ben Dooks <ben-linux@fluff.org>
Subject: [GIT] MFD pull request
Message-ID: <20080729000254.GB6637@caravaggio>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

If it's not too late, could you please pull those remaining 4 MFD patches ?
Those patches were depending on the ARM patches.

The following changes since commit c9272c4f9fbe2087beb3392f526dc5b19efaa56b:
  Linus Torvalds (1):
        Merge branch 'hotfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6

are available in the git repository at:

  git://git.o-hand.com/linux-mfd for-linus

Ben Dooks (2):
      mfd: Use to_platform_device instead of container_of
      mfd: Coding style fixes

Dmitry Baryshkov (1):
      mfd: accept pure device as a parent, not only platform_device

Mike Rapoport (1):
      mfd: add platform_data to mfd_cell

 drivers/mfd/mfd-core.c   |   32 +++++++++++++++-----------------
 drivers/mfd/tc6393xb.c   |    8 ++++++--
 include/linux/mfd/core.h |   30 +++++++++++++++---------------
 3 files changed, 36 insertions(+), 34 deletions(-)
