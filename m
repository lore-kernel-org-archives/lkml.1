Return-Path: <linux-kernel-owner+w=401wt.eu-S933589AbXK2Trs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589AbXK2Trs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933672AbXK2TqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:46:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:3835 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666AbXK2TqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:46:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ElWUDPi7oxEQufiCdfqJiKle5NwrSQTDVsbznoWorlkFGL7xX3/Af/n4RqBJGBaJEhL6rb1SJI8PNB+WyvNFaGq9elvki5yu+SfC2qfg+VTK8H9kVYtuBr838SSlq682cJoS8nYnjhRAX0WfnnOZMflaZ5m0wKy09zmF3tTWMxU=
Date: Thu, 29 Nov 2007 22:46:54 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: PPCML <linuxppc-dev@ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 5/5] PPC cleanup: powermac - do use for_each macro
Message-ID: <20071129194654.GF12123@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 arch/powerpc/platforms/powermac/low_i2c.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
index da2007e..864fbf4 100644
--- a/arch/powerpc/platforms/powermac/low_i2c.c
+++ b/arch/powerpc/platforms/powermac/low_i2c.c
@@ -585,8 +585,7 @@ static void __init kw_i2c_probe(void)
 	struct device_node *np, *child, *parent;
 
 	/* Probe keywest-i2c busses */
-	for (np = NULL;
-	     (np = of_find_compatible_node(np, "i2c","keywest-i2c")) != NULL;){
+	for_each_compatible_node(np, "i2c","keywest-i2c") {
 		struct pmac_i2c_host_kw *host;
 		int multibus, chans, i;
 
-- 
1.5.3.5
