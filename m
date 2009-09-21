Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbZIUSYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbZIUSYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 14:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZIUSYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 14:24:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45887 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZIUSX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 14:23:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 21 Sep 2009 20:23:36 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates post 2.6.31
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.96c67be01421d723@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive a few minor IEEE 1394/ FireWire subsystem fixes.

Michael Buesch (1):
      ieee1394: raw1394: Do not leak memory on failed trylock.

Stefan Richter (7):
      firewire: ohci: fix Self ID Count register mask (safeguard against buffer overflow)
      firewire: core: header file cleanup
      firewire: core: fix race with parallel PCI device probe
      firewire: core: fix topology map response handler
      firewire: sbp2: fix status reception
      firewire: sbp2: remove a workaround for Momobay FX-3A
      ieee1394: sbp2: remove a workaround for Momobay FX-3A

 drivers/firewire/core-card.c        |   13 +++++--------
 drivers/firewire/core-transaction.c |    2 +-
 drivers/firewire/core.h             |   14 ++++++++++++++
 drivers/firewire/ohci.c             |    4 ++--
 drivers/firewire/sbp2.c             |   16 ++++++++--------
 drivers/ieee1394/raw1394.c          |    4 +++-
 drivers/ieee1394/sbp2.c             |    3 +--
 include/linux/firewire.h            |   14 --------------
 8 files changed, 34 insertions(+), 36 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-==--= =--= =-=-=
http://arcgraph.de/sr/

