Return-Path: <linux-kernel-owner+w=401wt.eu-S1762343AbZE0Xdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762343AbZE0Xdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757976AbZE0Xdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:33:32 -0400
Received: from ns1.siteground150.com ([67.15.243.6]:48382 "EHLO
	serv01.siteground150.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbZE0Xdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:33:31 -0400
X-Greylist: delayed 3002 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 May 2009 19:33:31 EDT
MIME-Version: 1.0
Date: Wed, 27 May 2009 17:43:32 -0500
From: <lkml@reliableembeddedsystems.com>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org
Subject: [PATCH] fixed =?UTF-8?Q?=5Fmodinst=5Fpost=20-=20to=20pick=20up=20Cross=20?=
 =?UTF-8?Q?=24DEPMOD=20instead=20of=20host=20depmod?=
Message-ID: <7aed4bd738b1bd3b6da463ff66fa324e@reliableembeddedsystems.com>
User-Agent: RoundCube Webmail/0.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground150.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [0 0]
X-AntiAbuse: Sender Address Domain - reliableembeddedsystems.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Berger <robert.berger@reliableembeddedsystems.com>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 739fd34..d1dc869 100644
--- a/Makefile
+++ b/Makefile
@@ -1170,7 +1170,7 @@ _modinst_:
 PHONY += _modinst_post
 _modinst_post: _modinst_
        $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware
__fw_modinst
-       $(call cmd,depmod)
+       $(call cmd,$(DEPMOD))

 else # CONFIG_MODULES

--
1.5.4.5


