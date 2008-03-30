Return-Path: <linux-kernel-owner+w=401wt.eu-S1759641AbYC3W4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641AbYC3W4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758834AbYC3WyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:54:16 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53416 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758830AbYC3WyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:54:14 -0400
Date: Mon, 31 Mar 2008 01:54:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: sds@tycho.nsa.gov, jmorris@namei.org, eparis@parisplace.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] selinux/ss/services.c should #include <linux/selinux.h>
Message-ID: <20080330225402.GM28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the externs for its 
global code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 27 Feb 2008

eaeb567e2ce03ef3a7c5ed33e35def212ce2899a foobar
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index f374186..29fb216 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -40,6 +40,7 @@
 #include <linux/sched.h>
 #include <linux/audit.h>
 #include <linux/mutex.h>
+#include <linux/selinux.h>
 #include <net/netlabel.h>
 
 #include "flask.h"

