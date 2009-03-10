Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbZCJUGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbZCJUGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbZCJUGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:06:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48181 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858AbZCJUGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:06:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 10 Mar 2009 21:06:12 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/5] firewire: some simplifications in firewire-core + a fix
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.be62682e320707a0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next up:

 firewire: core: drop unused call parameters of close_transaction
 firewire: core: increase bus manager grace period
 firewire: core: simplify broadcast channel allocation
 firewire: core: optimize propagation of BROADCAST_CHANNEL

 drivers/firewire/fw-card.c        |  214 +++++-------------------------
 drivers/firewire/fw-device.c      |   45 +++++-
 drivers/firewire/fw-device.h      |    5
 drivers/firewire/fw-topology.c    |    1
 drivers/firewire/fw-transaction.c |   17 +-
 drivers/firewire/fw-transaction.h |    6
 6 files changed, 96 insertions(+), 192 deletions(-)
-- 
Stefan Richter
-=====-==--= --== -=-=-
http://arcgraph.de/sr/

