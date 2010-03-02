Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab0CBJDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 04:03:53 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56444 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0CBJDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 04:03:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BKy7KgPEiuN09F2BKnd3Qh+2g5uSD4Ua5I8Mr0yxyX0GDi7u1lXV5XcnIvJ5uR63pX
         2lFxEGFzpkq2qwJG+W6sOh3P/q2ZBnc7A7VczGpxosWS1eKwh9xmOiH5md3px227+9DY
         8Ffd5UNNgVxVuMwnF3gYh7MA6tVWjtYytib+E=
Date: Tue, 2 Mar 2010 17:03:43 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, sds@tycho.nsa.gov
Subject: [PATCH] Selinux: Remove unused headers slab.h in selinux/ss/symtab.c
Message-ID: <20100302090343.GA12759@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slab.h is unused in symtab.c, so remove it.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/selinux/ss/symtab.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/security/selinux/ss/symtab.c b/security/selinux/ss/symtab.c
index 837658a..bcf9f62 100644
--- a/security/selinux/ss/symtab.c
+++ b/security/selinux/ss/symtab.c
@@ -4,7 +4,6 @@
  * Author : Stephen Smalley, <sds@epoch.ncsc.mil>
  */
 #include <linux/kernel.h>
-#include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include "symtab.h"
-- 
1.6.5.3

