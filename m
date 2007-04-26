Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbXDZXrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbXDZXrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbXDZXrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:47:22 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35831 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753844AbXDZXrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:47:21 -0400
Date: Fri, 27 Apr 2007 01:47:32 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, ben.collins@ubuntu.com,
       stefanr@s5r6.in-berlin.de
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [-mm patch] unexport highlevel_host_reset
Message-ID: <20070426234732.GE3468@stusta.de>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 10:57:16PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc7-mm1:
>...
>  git-ieee1394.patch
>...
>  git trees
>...


highlevel_host_reset no longer has any modular users.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc7-mm2/drivers/ieee1394/ieee1394_core.c.old	2007-04-27 00:48:12.000000000 +0200
+++ linux-2.6.21-rc7-mm2/drivers/ieee1394/ieee1394_core.c	2007-04-27 00:48:19.000000000 +0200
@@ -1338,7 +1338,6 @@
 EXPORT_SYMBOL(hpsb_set_hostinfo_key);
 EXPORT_SYMBOL(hpsb_get_hostinfo_bykey);
 EXPORT_SYMBOL(hpsb_set_hostinfo);
-EXPORT_SYMBOL(highlevel_host_reset);
 
 /** nodemgr.c **/
 EXPORT_SYMBOL(hpsb_node_fill_packet);

