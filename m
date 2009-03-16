Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbZCPMmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbZCPMmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbZCPMm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:42:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37524 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbZCPMm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:42:28 -0400
Date: Mon, 16 Mar 2009 13:36:33 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PATCH] Document /proc/sys/net/core/netdev_budget
Message-ID: <20090316133633.2df4ed3e@dhcp-lab-109.englab.brq.redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NAPI poll parameter netdev_budget is not documented in kernel-docs. Since
it may have a substantial effect on at least some network loads, it should be.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com> 
---
 Documentation/filesystems/proc.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a87be42..830bad7 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1478,6 +1478,13 @@ of problems on the network like duplicate address or bad checksums. Normally,
 this should be enabled, but if the problem persists the messages can be
 disabled.
 
+netdev_budget
+-------------
+
+Maximum number of packets taken from all interfaces in one polling cycle (NAPI
+poll). In one polling cycle interfaces which are registered to polling are
+probed in a round-robin manner. The limit of packets in one such probe can be
+set per-device via sysfs class/net/<device>/weight .
 
 netdev_max_backlog
 ------------------
-- 
1.5.5.6

