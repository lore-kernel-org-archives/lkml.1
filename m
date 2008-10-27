Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbYJ0WZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbYJ0WZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYJ0WZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:25:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51148 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYJ0WZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:25:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 27 Oct 2008 23:24:55 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 2.6.27.y 0/6] firewire: proposed patches for -stable
To: stable@kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <tkrat.df6e0a4afb92ef6e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -stable folks,

please consider to add the following fixes for the 2.6.27.y series.
Coming up as replies:

1/6  firewire: fix setting tag and sy in iso transmission
2/6  firewire: fix ioctl() return code
3/6  firewire: Survive more than 256 bus resets
4/6  firewire: fix struct fw_node memory leak
5/6  firewire: fw-sbp2: delay first login to avoid retries
6/6  firewire: fw-sbp2: fix races

 drivers/firewire/fw-cdev.c        |    6 ++--
 drivers/firewire/fw-sbp2.c        |   38 +++++++++++++++++++++---------
 drivers/firewire/fw-topology.c    |    6 +++-
 drivers/firewire/fw-transaction.h |    2 -
 4 files changed, 35 insertions(+), 17 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-==--- =-=- ==-==
http://arcgraph.de/sr/


