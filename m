Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbYB0V3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbYB0V3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbYB0V3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:29:06 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42093 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbYB0V3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:29:04 -0500
Date: Wed, 27 Feb 2008 23:20:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: paul.moore@hp.com, sds@tycho.nsa.gov, jmorris@namei.org,
       eparis@parisplace.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.or
Subject: [2.6 patch] selinux/netlabel.c should #include "netlabel.h"
Message-ID: <20080227212042.GK29269@cs181133002.pp.htv.fi>
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
1f65757bac3e82514b447822ab30ee10d33a59a2 foobar
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index 0fa2be4..6d22d76 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -34,6 +34,7 @@
 
 #include "objsec.h"
 #include "security.h"
+#include "netlabel.h"
 
 /**
  * selinux_netlbl_sidlookup_cached - Cache a SID lookup

