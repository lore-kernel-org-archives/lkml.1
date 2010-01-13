Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696Ab0AMKfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab0AMKfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686Ab0AMKfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:35:34 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:61414 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755680Ab0AMKfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:35:32 -0500
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2010 05:35:32 EST
Date: Wed, 13 Jan 2010 11:26:04 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, felipe.balbi@nokia.com,
       sameo@linux.intel.com
Cc: siccegge@stud.informatik.uni-erlangen.de,
       Reinhard.Tartler@informatik.uni-erlangen.de
Subject: [PATCH] typo in kernel source (INPUT_TWL4030_PWBUTTON)
Message-ID: <20100113102604.GA7021@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
Organization: Vamos I4 Uni Erlangen
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	While working on this we detected a spelling error in
drivers/mfd/twl-core.c which can be corrected using the attached
patch.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

--M9NhX3UHpAaciwkO
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Correct-spelling-for-config-INPUT_TWL4030_PWRBUTTON.patch"

>From 83cadb82b627f35333742d1585c2f63e40e76ef4 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Wed, 13 Jan 2010 10:56:27 +0100
Subject: [PATCH] Correct spelling for config INPUT_TWL4030_PWRBUTTON

While the non-module variant of the TWL4030 Powerbutton is querried
with INPUT_TWL4030_PWRBUTTON, the _MODULE variant misses the R and is
checking therefor INPUT_TWL4030_PWBUTTON which won't work as there's
nosuch option in kconfig
---
 drivers/mfd/twl-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 2a76065..aeaeac4 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -129,7 +129,7 @@
 #define TWL_NUM_SLAVES		4
 
 #if defined(CONFIG_INPUT_TWL4030_PWRBUTTON) \
-	|| defined(CONFIG_INPUT_TWL4030_PWBUTTON_MODULE)
+	|| defined(CONFIG_INPUT_TWL4030_PWRBUTTON_MODULE)
 #define twl_has_pwrbutton()	true
 #else
 #define twl_has_pwrbutton()	false
-- 
1.6.3.3


--M9NhX3UHpAaciwkO--
