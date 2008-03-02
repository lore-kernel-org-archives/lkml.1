Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYCBMst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYCBMst (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 07:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYCBMsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 07:48:39 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39947 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbYCBMsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 07:48:39 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 2 Mar 2008 13:47:52 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.14d846ed63cc91c2@s5r6.in-berlin.de>
Message-ID: <tkrat.948f418ebe464164@s5r6.in-berlin.de>
References: <tkrat.459cc31de75e4149@s5r6.in-berlin.de>
 <tkrat.68585c2b7aee00eb@s5r6.in-berlin.de>
 <tkrat.14d846ed63cc91c2@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following updates for the firewire subsystem.  They fix
module unloading.  I will follow up with the combined full log and diff.
Diffstat and shortlog:

 drivers/firewire/fw-card.c        |   61 ++++++++++++++++++++--------
 drivers/firewire/fw-device.c      |   21 +++-------
 drivers/firewire/fw-device.h      |   16 +++++++-
 drivers/firewire/fw-sbp2.c        |   50 +++++++++++++++---------
 drivers/firewire/fw-topology.c    |    1 +
 drivers/firewire/fw-transaction.h |    2 +
 6 files changed, 97 insertions(+), 54 deletions(-)

Stefan Richter (3):
      firewire: fw-sbp2: better fix for NULL pointer dereference in scsi_remove_device
      firewire: potentially invalid pointers used in fw_card_bm_work
      firewire: fix crash in automatic module unloading

Thanks,
-- 
Stefan Richter
-=====-==--- --== ---=-
http://arcgraph.de/sr/

