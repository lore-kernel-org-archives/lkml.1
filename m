Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0CBHJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 02:09:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46358 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab0CBHJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 02:09:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=rUxfBV+HkOo8wLwWaetZ0xe+3sxoyd+l+zMf3MSuXF3njYlvOElUjTKfy9JPq6Ebb3
         wgWfXEkxxgOn4zY5Aq4v2n4ZKZ9GG6nxIRzX47uAsDKP0ykthLosxy45whLmgQsxX8el
         IBYrm/mH96Jrwf+5TdpcNyMZL5mexHAr6SiaM=
Date: Tue, 2 Mar 2010 15:08:58 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org
Subject: [PATCH] Selinux: Remove unused headers list.h in selinux/netlink.c
Message-ID: <20100302070858.GA5178@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

list.h is unused in netlink.c, so remove it.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/selinux/netlink.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/security/selinux/netlink.c b/security/selinux/netlink.c
index 1ae5564..7d7be29 100644
--- a/security/selinux/netlink.c
+++ b/security/selinux/netlink.c
@@ -13,7 +13,6 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/kernel.h>
-#include <linux/list.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
 #include <linux/selinux_netlink.h>
-- 
1.6.5.3

