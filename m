Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbYBCXF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbYBCXF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYBCXFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:05:50 -0500
Received: from xenotime.net ([66.160.160.81]:36595 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751978AbYBCXFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:05:50 -0500
Date: Sun, 3 Feb 2008 15:05:48 -0800 (PST)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org, dwmw2@infradead.org
Subject: [PATCH 1/8] kernel-doc: fix audit warnings
Message-ID: <Pine.LNX.4.64.0802031426330.3021@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in audit.c.

Warning(linux-2.6.24-git12//kernel/audit.c:1268): No description found for parameter 'string'
Warning(linux-2.6.24-git12//kernel/audit.c:1268): No description found for parameter 'len'`

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
  kernel/audit.c |    4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.24-git12.orig/kernel/audit.c
+++ linux-2.6.24-git12/kernel/audit.c
@@ -1261,8 +1261,8 @@ static void audit_log_n_string(struct au

  /**
   * audit_string_contains_control - does a string need to be logged in hex
- * @string - string to be checked
- * @len - max length of the string to check
+ * @string: string to be checked
+ * @len: max length of the string to check
   */
  int audit_string_contains_control(const char *string, size_t len)
  {
