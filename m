Return-Path: <linux-kernel-owner+w=401wt.eu-S1760402AbYFYQ3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760402AbYFYQ3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbYFYQ1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:27:53 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59434 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760302AbYFYQ1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:27:52 -0400
Date: Wed, 25 Jun 2008 19:25:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Corentin Chary <corentincj@iksaif.net>, Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] make eeepc-laptop.c:cm_{g,s}etv[] static
Message-ID: <20080625162547.GK10285@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global cm_{g,s}etv[] static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 5 May 2008

 drivers/misc/eeepc-laptop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

4e41a5023994160e27b2b194d9e67e2208c948de diff --git a/drivers/misc/eeepc-laptop.c b/drivers/misc/eeepc-laptop.c
index 6d72760..9e8d79e 100644
--- a/drivers/misc/eeepc-laptop.c
+++ b/drivers/misc/eeepc-laptop.c
@@ -87,7 +87,7 @@ enum {
 	CM_ASL_LID
 };
 
-const char *cm_getv[] = {
+static const char *cm_getv[] = {
 	"WLDG", NULL, NULL, NULL,
 	"CAMG", NULL, NULL, NULL,
 	NULL, "PBLG", NULL, NULL,
@@ -96,7 +96,7 @@ const char *cm_getv[] = {
 	"CRDG", "LIDG"
 };
 
-const char *cm_setv[] = {
+static const char *cm_setv[] = {
 	"WLDS", NULL, NULL, NULL,
 	"CAMS", NULL, NULL, NULL,
 	"SDSP", "PBLS", "HDPS", NULL,

