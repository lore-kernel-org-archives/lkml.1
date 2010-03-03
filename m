Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab0CCFa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:30:58 -0500
Received: from mail-gx0-f227.google.com ([209.85.217.227]:39230 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0CCFaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:30:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tz2F/KBIBw+C0+DUyqVTMjt7Y8axJFm446I8QRwLT22ZGc0s+onLDIO7UyCFuEeEKb
         DUdN4ZYm47zJ3wX0VQbWgxuJkVIfwpiLY3/OddEKcntdIpxqZRpw7Slpq3g2IWtdhueS
         N5nk8pXzw21Cg/c3uZowOZA2Fz6oSUpB9CeuY=
Date: Wed, 3 Mar 2010 21:29:37 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org
Subject: [PATCH] Selinux: Remove unused headers skbuff.h in selinux/nlmsgtab.c
Message-ID: <20100303132937.GB2716@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

skbuff.h is already included by netlink.h, so remove it.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/selinux/nlmsgtab.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index dd7cc6d..75ec0c6 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -11,7 +11,6 @@
  */
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/skbuff.h>
 #include <linux/netlink.h>
 #include <linux/rtnetlink.h>
 #include <linux/if.h>
-- 
1.6.5.3

