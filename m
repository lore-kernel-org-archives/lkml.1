Return-Path: <linux-kernel-owner+w=401wt.eu-S1760493AbZBYUkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493AbZBYUkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbZBYUjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:39:46 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:15876 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402AbZBYUjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:39:45 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 3/8] appletalk: fix warning: format not a string literal and
	no ...
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Feb 2009 21:31:59 +0100
Message-ID: <20090225203145.6251.44085.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090225203012.6251.32002.stgit@vmbox.hanneseder.net>
References: <20090225203012.6251.32002.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Use 'static const char[]' instead of 'static char[]', and
since the data is const now it can be placed in __initconst.

Fix this warning:
  net/appletalk/ddp.c: In function 'atalk_init':
  net/appletalk/ddp.c:1894: warning: format not a string literal and no format arguments

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 net/appletalk/ddp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 510a678..cf05c43 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1877,7 +1877,7 @@ EXPORT_SYMBOL(aarp_send_ddp);
 EXPORT_SYMBOL(atrtr_get_dev);
 EXPORT_SYMBOL(atalk_find_dev_addr);
 
-static char atalk_err_snap[] __initdata =
+static const char atalk_err_snap[] __initconst =
 	KERN_CRIT "Unable to register DDP with SNAP.\n";
 
 /* Called by proto.c on kernel start up */

