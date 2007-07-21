Return-Path: <linux-kernel-owner+w=401wt.eu-S934543AbXGULVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934543AbXGULVA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 07:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761228AbXGULUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 07:20:52 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:51340 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752290AbXGULUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 07:20:51 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [PATCH] drivers/char/hpet.c: integer constant is too large for "long" type
Date: Sat, 21 Jul 2007 14:19:44 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707211419.47680.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

Following trivial patch silents

drivers/char/hpet.c:76: warning: integer constant is too large for "long" type

warning (with gcc-3.4.6)

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
 
 drivers/char/hpet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index ba0e74a..23fadf5 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -73,7 +73,7 @@ static struct clocksource clocksource_hpet = {
         .name           = "hpet",
         .rating         = 250,
         .read           = read_hpet,
-        .mask           = 0xffffffffffffffff,
+        .mask           = 0xffffffffffffffffLL,
         .mult           = 0, /*to be caluclated*/
         .shift          = 10,
         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
