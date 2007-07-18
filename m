Return-Path: <linux-kernel-owner+w=401wt.eu-S934474AbXGRWi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474AbXGRWi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762240AbXGRWib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:38:31 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56377 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761606AbXGRWia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:38:30 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <469E9635.3060102@s5r6.in-berlin.de>
Date: Thu, 19 Jul 2007 00:37:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Subject: [GIT PULL] FireWire updates (repost)
References: <tkrat.f5ba2b840fcda9e5@s5r6.in-berlin.de> <469E93AF.3080202@s5r6.in-berlin.de>
In-Reply-To: <469E93AF.3080202@s5r6.in-berlin.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seems my posting from half an hour ago got lost somehow.  Another try,
same message:  Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following few fixes and a SCSI API update for the
FireWire subsystem.

 drivers/firewire/fw-ohci.c        |    3 ++-
 drivers/firewire/fw-sbp2.c        |   16 +++++++---------
 drivers/firewire/fw-transaction.c |    9 +++------
 drivers/firewire/fw-transaction.h |    4 ++++
 4 files changed, 16 insertions(+), 16 deletions(-)

Stefan Richter (5):
      firewire: fw-ohci: flush MMIO write before msleep
      firewire: fw-ohci: fix "scheduling while atomic"
      firewire: remove bogus check in fw_core_handle_request
      firewire: fix memory leak of fw_request instances
      firewire: fw-sbp2: convert to new SCSI data buffer accessors
-- 
Stefan Richter
-=====-=-=== -=== =--==
http://arcgraph.de/sr/
