Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbZIFQqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbZIFQqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 12:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZIFQqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 12:46:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48841 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbZIFQqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 12:46:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 6 Sep 2009 18:46:17 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/6] firewire: minor fixes and cleanups
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, PaX Team <pageexec@freemail.hu>
Message-ID: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following as replies to this message:

[1/6 update] firewire: core: reduce stack usage in bus reset tasklet
[2/6] firewire: ohci: fix Self ID Count register mask (safeguard against buffer overflow)
[3/6] firewire: core: header file cleanup
[4/6] firewire: core: fix race with parallel PCI device probe
[5/6] firewire: reduce some memsets
[6/6] firewire: sbp2: fix status reception

 drivers/firewire/core-card.c     |   32 +++++++++++++++----------------
 drivers/firewire/core-topology.c |    2 -
 drivers/firewire/core.h          |   16 ++++++++++++++-
 drivers/firewire/ohci.c          |   21 +++++++++++++-------
 drivers/firewire/sbp2.c          |   13 ++++++------
 include/linux/firewire.h         |   28 ---------------------------
 6 files changed, 53 insertions(+), 59 deletions(-)
-- 
Stefan Richter
-=====-==--= =--= --==-
http://arcgraph.de/sr/

