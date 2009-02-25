Return-Path: <linux-kernel-owner+w=401wt.eu-S1762052AbZBYUiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762052AbZBYUiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbZBYUhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:37:45 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:52131 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535AbZBYUho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:37:44 -0500
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 15:37:22 EST
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 4/8] [NET] sysctl: fix sparse warning: Should it be static?
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Feb 2009 21:32:14 +0100
Message-ID: <20090225203208.6251.48572.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090225203012.6251.32002.stgit@vmbox.hanneseder.net>
References: <20090225203012.6251.32002.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Include header file.

Fix this sparse warning:
  net/core/sysctl_net_core.c:123:32: warning: symbol 'net_core_path' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 net/core/sysctl_net_core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 83d3398..7db1de0 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -11,6 +11,7 @@
 #include <linux/socket.h>
 #include <linux/netdevice.h>
 #include <linux/init.h>
+#include <net/ip.h>
 #include <net/sock.h>
 
 static struct ctl_table net_core_table[] = {

