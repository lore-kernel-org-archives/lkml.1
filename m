Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbYGKP2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbYGKP2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbYGKP2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:28:14 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:24961 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbYGKP2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:28:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=oFYzJG5c4TL8IjIlBQ115AhoiUB7zUvY6G/MAAA2j0h9TndWbuAPsJKoK3jhBIZUFR
         bjUT/Zup+7RkI67yQBoPmCavsILo7qjCCM1Ub9XA0TLWFkgUC328Lq++Yka8od+9FWRf
         j0pzTzXu2q4xir6z6ZsG4FkskJtm5y61hBk78=
Subject: [PATCH] regulator: include suspend.h in machine.h for
	suspend_state_t
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 11 Jul 2008 17:28:10 +0200
Message-Id: <1215790090.16329.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/regulator/machine.h shouldn't depend on files including this
header to have included linux/suspend.h before.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 include/linux/regulator/machine.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 60e6873..bed2b5e 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -16,6 +16,7 @@
 #define __LINUX_REGULATOR_MACHINE_H_
 
 #include <linux/regulator/consumer.h>
+#include <linux/suspend.h>
 
 struct regulator;
 
-- 
1.5.6.2


