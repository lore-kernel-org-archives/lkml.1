Return-Path: <linux-kernel-owner+w=401wt.eu-S1751552AbZJWBxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbZJWBxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 21:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZJWBxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 21:53:36 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:35627 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZJWBxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 21:53:35 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Oct 2009 21:53:35 EDT
Date: Fri, 23 Oct 2009 09:48:37 +0800
From: fangxiaozhi 00110321 <huananhu@huawei.com>
Subject: PATCH 23/10]Optimize the upload speed for PPP connection.
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, zihan@huawei.com, greg@kroah.com,
       haegar@sdinet.de
Message-id: <fae097f21b27.1b27fae097f2@huawei.com>
MIME-version: 1.0
X-Mailer: iPlanet Messenger Express 5.2 HotFix 2.14 (built Aug  8 2006)
Content-type: text/plain; charset=us-ascii
Content-language: zh-CN
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-Accept-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: fangxiaozhi <huananhu@huawei.com>
1. This patch is based on the kernel of 2.6.32-rc4 
2. In this patch, we enlarge the out buffer size to optimize the upload speed for the ppp connection. Then it can support the upload of HSUPA data cards.
Signed-off-by: fangxiaozhi <huananhu@huawei.com>
-----------------------------------------------------------------------------------------
--- a/drivers/net/ppp_async.c	2009-10-12 05:43:56.000000000 +0800
+++ b/drivers/net/ppp_async.c	2009-10-15 16:29:56.000000000 +0800
@@ -36,7 +36,7 @@
 
 #define PPP_VERSION	"2.4.2"
 
-#define OBUFSIZE	256
+#define OBUFSIZE	2048
 
 /* Structure for storing local state. */
 struct asyncppp {

******************************************************************************************
 This email and its attachments contain confidential information from HUAWEI, which is intended only for the person or entity whose address is listed above. Any use of the information contained here in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this email in error, please notify the sender by phone or email
 immediately and delete it!
 *****************************************************************************************
