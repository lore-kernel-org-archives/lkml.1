Return-Path: <linux-kernel-owner+w=401wt.eu-S1762218AbXIZTnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762218AbXIZTnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757877AbXIZTng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:43:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48119 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758340AbXIZTnf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:43:35 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 26 Sep 2007 21:42:30 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: What's in linux1394-2.6.git
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.37c4d4be47f119fa@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I heard that project tree maintainers are encouraged to post merge plans
in time, so I'm going to do so now too.  Although this time there isn't
much in store for drivers/{ieee1394,firewire} for the merge window
because we all got sidetracked lately...  It's basically bugfixes which
I felt were too late for 2.6.23.


To be merged:

Jean Delvare (1):
      ieee1394: pcilynx: I2C cleanups

Satyam Sharma (1):
      ieee1394: Fix kthread stopping in nodemgr_host_thread

Stefan Richter (18):
      ieee1394: eth1394: superfluous local variable
      ieee1394: eth1394: fix lock imbalance
      ieee1394: pcilynx: superfluous local variables
      ieee1394: sbp2: fix unsafe iteration over list of devices
      firewire: optimize fw_core_add_address_handler
      firewire: fw-core: local variable shadows a global one
      firewire: fw-sbp2: always enable IRQs before calling command ORB callback
      firewire: fw-sbp2: add support for multiple logical units per target
      firewire: fw-sbp2: expose module parameter for workarounds
      firewire: fw-sbp2: use an own workqueue (fix system responsiveness)
      firewire: fw-ohci: enforce read order for selfID generation
      firewire: fw-ohci: fix includes
      firewire: fw-ohci: reorder includes
      firewire: fw-ohci: log posted write errors
      firewire: fw-ohci: missing dma_unmap_single
      firewire: fw-ohci: check for misconfigured bus (phyID == 63)
      ieee1394: nodemgr: fix leak of struct csr1212_keyval
      ieee1394: csr1212: proper refcounting


On hold for debugging:

Kristian Høgsberg (1):
      firewire: Fix pci resume to not pass in a __be32 config rom.

-- 
Stefan Richter
-=====-=-=== =--= ==-=-
http://arcgraph.de/sr/

