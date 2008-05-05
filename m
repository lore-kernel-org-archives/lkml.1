Return-Path: <linux-kernel-owner+w=401wt.eu-S1761324AbYEES24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324AbYEES24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760518AbYEES0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:26:34 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54960 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760501AbYEES0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:26:33 -0400
Date: Mon, 5 May 2008 21:25:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Corentin Chary <corentincj@iksaif.net>, Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make eeepc-laptop.c:cm_{g,s}etv[] static
Message-ID: <20080505182526.GO17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global cm_{g,s}etv[] static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

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

