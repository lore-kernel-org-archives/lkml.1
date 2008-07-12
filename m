Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbYGLMss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbYGLMss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 08:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYGLMsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 08:48:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49829 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbYGLMsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 08:48:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 12 Jul 2008 14:48:23 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 0/4] firewire: keeping accesses to fw_transaction in check
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.3186168349c88b15@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Fenlason pointed me to a race condition in firewire-core;  here are
some patches for it:

[1/4] firewire: fix race of bus reset with request transmission
[2/4] firewire: fully initialize fw_transaction before marking it pending
[3/4] firewire: small fw_fill_request cleanup
[4/4] firewire: warn on unfinished transactions during card removal

 drivers/firewire/fw-card.c        |    2 +-
 drivers/firewire/fw-topology.c    |    2 --
 drivers/firewire/fw-transaction.c |   21 +++++++++------------
 3 files changed, 10 insertions(+), 15 deletions(-)

Both the diffstat's +/- balance and initial testing look fine so far.
-- 
Stefan Richter
-=====-==--- -=== -==--
http://arcgraph.de/sr/

