Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbXBYT2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbXBYT2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 14:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXBYT2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 14:28:42 -0500
Received: from rrcs-24-153-217-226.sw.biz.rr.com ([24.153.217.226]:36279 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395AbXBYT2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 14:28:41 -0500
Subject: Re: [PATCH 3/7] cxgb3 - FW version update
From: Steve Wise <swise@opengridcomputing.com>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070225004401.20831.3292.stgit@localhost.localdomain>
References: <20070225004401.20831.3292.stgit@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 13:28:39 -0600
Message-Id: <1172431719.4717.8.camel@stevo-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Divy,

You missed a printk change.  Here is an updated patch.

------------

Update FW version to 3.2

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/net/cxgb3/t3_hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 365a7f5..08a6295 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -884,11 +884,11 @@ int t3_check_fw_version(struct adapter *
 	major = G_FW_VERSION_MAJOR(vers);
 	minor = G_FW_VERSION_MINOR(vers);
 
-	if (type == FW_VERSION_T3 && major == 3 && minor == 1)
+	if (type == FW_VERSION_T3 && major == 3 && minor == 2)
 		return 0;
 
 	CH_ERR(adapter, "found wrong FW version(%u.%u), "
-	       "driver needs version 3.1\n", major, minor);
+	       "driver needs version 3.2\n", major, minor);
 	return -EINVAL;
 }
 


