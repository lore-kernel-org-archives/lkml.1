Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbXIZJqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbXIZJqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 05:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbXIZJqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 05:46:43 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:4439 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbXIZJqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 05:46:42 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: Paul Mackerras <paulus@samba.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/5] ibmebus: More speaking error return code in ibmebus_store_probe()
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, Paul Mackerras <pmac@au1.ibm.com>
References: <200709261143.24735.fenkes@de.ibm.com>
In-Reply-To: <200709261143.24735.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 8283
Date: Wed, 26 Sep 2007 11:46:34 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709261146.35466.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 arch/powerpc/kernel/ibmebus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index c1e2963..0bd186c 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -268,10 +268,10 @@ static ssize_t ibmebus_store_probe(struct bus_type *bus,
 		return -ENOMEM;
 
 	if (bus_find_device(&ibmebus_bus_type, NULL, path,
-			     ibmebus_match_path)) {
+			    ibmebus_match_path)) {
 		printk(KERN_WARNING "%s: %s has already been probed\n",
 		       __FUNCTION__, path);
-		rc = -EINVAL;
+		rc = -EEXIST;
 		goto out;
 	}
 
-- 
1.5.2


