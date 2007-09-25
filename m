Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbXIYMNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbXIYMNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbXIYMNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:13:42 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:20443 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbXIYMNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:13:41 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: Paul Mackerras <paulus@samba.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] ibmebus: More speaking error return code in ibmebus_store_probe()
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
       Paul Mackerras <pmac@au1.ibm.com>
References: <200709251410.29780.fenkes@de.ibm.com>
In-Reply-To: <200709251410.29780.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 8152
Date: Tue, 25 Sep 2007 14:13:26 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709251413.26873.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 arch/powerpc/kernel/ibmebus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index 379472f..8c08a98 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -270,10 +270,10 @@ static ssize_t ibmebus_store_probe(struct bus_type *bus,
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


