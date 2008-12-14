Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbYLNSRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbYLNSRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 13:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYLNSRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 13:17:46 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35748 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYLNSRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 13:17:45 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Dec 2008 19:17:16 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/4] firewire: cdev resources and events...
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Jay Fenlason <fenlason@redhat.com>
In-Reply-To: <492AEF9D.5010307@s5r6.in-berlin.de>
Message-ID: <tkrat.7bf80e1dd5c90f36@s5r6.in-berlin.de>
References: <20081124163728.GA5826@redhat.com>
 <492AEED8.9030102@s5r6.in-berlin.de> <492AEF9D.5010307@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coming in follow-ups:
1/4 firewire: cdev: fix race of fw_device_op_release with bus reset
2/4 firewire: cdev: use an idr rather than a linked list for resources
3/4 firewire: cdev: address handler input validation
4/4 firewire: core: remove outdated comment

 drivers/firewire/fw-cdev.c        |  180 ++++++++++++++++++++----------
 drivers/firewire/fw-transaction.c |   34 +++--
 2 files changed, 142 insertions(+), 72 deletions(-)
-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/

