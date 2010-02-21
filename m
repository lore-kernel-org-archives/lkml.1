Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab0BUQz4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 11:55:56 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58335 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab0BUQzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 11:55:55 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 21 Feb 2010 17:55:43 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/8] firewire: misc updates
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coming up as replies:  Several cleanups, one fix for a bug that went
unnoticed for an astonishingly long time, and a feature that two or so
people had asked for a while ago (a parameter for firewire-ohci similar
to firewire-sbp2.workarounds).

[PATCH 1/8] firewire: core: change type of a data buffer
[PATCH 2/8] firewire: core: combine a bit of repeated code
[PATCH 3/8] firewire: ohci: remove unused dualbuffer IR code
[PATCH 4/8] firewire: ohci: reorder struct fw_ohci for better cache efficiency
[PATCH 5/8] firewire: ohci: use an ID table for quirks detection
[PATCH 6/8] firewire: ohci: add module parameter to activate quirk fixes
[PATCH 7/8] firewire: ohci: fix IR/IT context mask mixup
[PATCH 8/8] firewire: ohci: extend initialization log message

 drivers/firewire/core-cdev.c |  342 ++++++++++++++++-------------------
 drivers/firewire/ohci.c      |  289 ++++++-----------------------
 include/linux/pci_ids.h      |    1 
 3 files changed, 223 insertions(+), 409 deletions(-)
-- 
Stefan Richter
-=====-==-=- --=- =-=-=
http://arcgraph.de/sr/

