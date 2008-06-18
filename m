Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYFRWar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYFRWar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 18:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYFRWah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 18:30:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57416 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbYFRWag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 18:30:36 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 19 Jun 2008 00:30:27 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: backlog of firewire fixes
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.6c5fe8fdad483627@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi lists,

this is a heads-up that I plan to send the following updates to Linus on
Friday --- unless anybody has issues with them; please tell me so.  The
diffstat looks quite big for this late -rc phase, but the bulk of it is
just Kconfig documentation rewording and reordering, and indentation
churn by the printk prefixes patch.

The updates are staged in

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

and consist of

Stefan Richter (9):
      firewire: don't panic on invalid AR request buffer
      firewire: fw-ohci: use of uninitialized data in AR handler
      firewire: fw-ohci: disable PHY packet reception into AR context
      firewire: fw-ohci: write selfIDBufferPtr before LinkControl.rcvSelfID
      firewire: fill_bus_reset_event needs lock protection
      firewire: fw-ohci: unify printk prefixes
      firewire: deadline for PHY config transmission
      firewire: Kconfig menu touch-up
      ieee1394: Kconfig menu touch-up

 drivers/firewire/Kconfig          |   32 ++++----
 drivers/firewire/fw-cdev.c        |    9 ++-
 drivers/firewire/fw-ohci.c        |  110 ++++++++++++++-------------
 drivers/firewire/fw-transaction.c |   52 +++++++++----
 drivers/ieee1394/Kconfig          |  118 ++++++++++++++++-------------
 5 files changed, 180 insertions(+), 141 deletions(-)

All patches have been seen on linux1394-devel and on lkml.
-- 
Stefan Richter
-=====-==--- -==- =--==
http://arcgraph.de/sr/

