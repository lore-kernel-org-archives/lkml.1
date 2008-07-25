Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYGYSb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYGYSb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbYGYSbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:31:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:32867 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYGYSbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:31:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 25 Jul 2008 20:31:02 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.276cff1d88ff801f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive a few FireWire subsystem fixes.

JiSheng Zhang (1):
      firewire: queue the right number of data

Stefan Richter (7):
      firewire: fix race of bus reset with request transmission
      firewire: fully initialize fw_transaction before marking it pending
      firewire: small fw_fill_request cleanup
      firewire: warn on unfinished transactions during card removal
      firewire: fw-ohci: TSB43AB22/A dualbuffer workaround
      firewire: avoid memleak after phy config transmit failure
      firewire: state userland requirements in Kconfig help

 drivers/firewire/Kconfig          |    9 +++-
 drivers/firewire/fw-card.c        |    2 +-
 drivers/firewire/fw-cdev.c        |    6 +-
 drivers/firewire/fw-ohci.c        |   37 +++++++++-----
 drivers/firewire/fw-topology.c    |    2 -
 drivers/firewire/fw-transaction.c |   79 +++++++++++------------------
 include/linux/pci_ids.h           |    1 +
 7 files changed, 66 insertions(+), 70 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-==--- -=== ==--=
http://arcgraph.de/sr/

