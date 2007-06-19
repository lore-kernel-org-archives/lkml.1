Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbXFSWvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbXFSWvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbXFSWvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:51:05 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:58578 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759830AbXFSWvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:51:02 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 00:50:50 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 8/12] fix compile error (missing include)
Message-ID: <20070619225050.GJ5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Jun 2007 22:49:54.0325 (UTC)
 FILETIME=[27226C50:01C7B2C4]
X-WSS-ID: 6A6682471S4852432-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compile error:

In file included from drivers/infiniband/core/addr.c:32:
include/linux/inetdevice.h:15: error: '__NET_IPV4_CONF_MAX' undeclared here (not in a function)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 include/linux/inetdevice.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index ae04901..d83fee2 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -8,6 +8,7 @@
 #include <linux/netdevice.h>
 #include <linux/rcupdate.h>
 #include <linux/timer.h>
+#include <linux/sysctl.h>
 
 struct ipv4_devconf
 {
-- 
1.5.0.7




