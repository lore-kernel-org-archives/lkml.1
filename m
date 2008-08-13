Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYHMWvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYHMWvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 18:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbYHMWuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 18:50:55 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37319 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbYHMWuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 18:50:55 -0400
Date: Wed, 13 Aug 2008 15:51:48 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH] coretemp: Recognize Nehalem CPUs
Message-ID: <20080813225147.GE28450@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add in the CPUID for Nehalem chips.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/coretemp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 70239ac..9f2e423 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -416,7 +416,8 @@ static int __init coretemp_init(void)
 		/* check if family 6, models 0xe, 0xf, 0x16, 0x17 */
 		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
 		    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
-			(c->x86_model == 0x16) || (c->x86_model == 0x17))) {
+			(c->x86_model == 0x16) || (c->x86_model == 0x17) ||
+			(c->x86_model == 0x1A))) {
 
 			/* supported CPU not found, but report the unknown
 			   family 6 CPU */
