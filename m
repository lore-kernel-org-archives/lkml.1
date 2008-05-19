Return-Path: <linux-kernel-owner+w=401wt.eu-S1765698AbYESWO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765698AbYESWO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760066AbYESWJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:09:30 -0400
Received: from xenotime.net ([66.160.160.81]:58087 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1765100AbYESWJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:09:26 -0400
Date: Mon, 19 May 2008 15:09:21 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: viro@zeniv.linux.org.uk, eparis@redhat.com, akpm@linux-foundation.org
Subject: [PATCH] audit: fix kernel-doc parameter notation
Message-ID: <Pine.LNX.4.64.0805191508090.20279@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix auditfilter kernel-doc misssing parameter description:

Warning(lin2626-rc3//kernel/auditfilter.c:1551): No description found for parameter 'sessionid'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/auditfilter.c |    1 +
 1 file changed, 1 insertion(+)

--- lin2626-rc3.orig/kernel/auditfilter.c
+++ lin2626-rc3/kernel/auditfilter.c
@@ -1544,6 +1544,7 @@ static void audit_log_rule_change(uid_t 
  * @data: payload data
  * @datasz: size of payload data
  * @loginuid: loginuid of sender
+ * @sessionid: sessionid for netlink audit message
  * @sid: SE Linux Security ID of sender
  */
 int audit_receive_filter(int type, int pid, int uid, int seq, void *data,
