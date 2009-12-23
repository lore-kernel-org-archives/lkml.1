Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbZLWNNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbZLWNNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 08:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbZLWNNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 08:13:20 -0500
Received: from mx2.zhaw.ch ([160.85.104.51]:61448 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbZLWNNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 08:13:19 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] regulator/lp3971: Storage class should be before const qualifier
Date: Wed, 23 Dec 2009 14:13:17 +0100
Message-Id: <1261573997-9126-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.6.3.3
X-PMX-Version: 5.5.8.383112, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2009.12.23.130024
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/regulator/lp3971.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 76d08c2..9416f0c 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -54,7 +54,7 @@ static int lp3971_set_bits(struct lp3971 *lp3971, u8 reg, u16 mask, u16 val);
 #define LP3971_BUCK2_BASE 0x29
 #define LP3971_BUCK3_BASE 0x32
 
-const static int buck_base_addr[] = {
+static const int buck_base_addr[] = {
 	LP3971_BUCK1_BASE,
 	LP3971_BUCK2_BASE,
 	LP3971_BUCK3_BASE,
@@ -63,7 +63,7 @@ const static int buck_base_addr[] = {
 #define LP3971_BUCK_TARGET_VOL1_REG(x) (buck_base_addr[x])
 #define LP3971_BUCK_TARGET_VOL2_REG(x) (buck_base_addr[x]+1)
 
-const static int buck_voltage_map[] = {
+static const int buck_voltage_map[] = {
 	   0,  800,  850,  900,  950, 1000, 1050, 1100,
 	1150, 1200, 1250, 1300, 1350, 1400, 1450, 1500,
 	1550, 1600, 1650, 1700, 1800, 1900, 2500, 2800,
@@ -96,17 +96,17 @@ const static int buck_voltage_map[] = {
 #define LDO_VOL_CONTR_SHIFT(x) ((x & 1) << 2)
 #define LDO_VOL_CONTR_MASK 0x0f
 
-const static int ldo45_voltage_map[] = {
+static const int ldo45_voltage_map[] = {
 	1000, 1050, 1100, 1150, 1200, 1250, 1300, 1350,
 	1400, 1500, 1800, 1900, 2500, 2800, 3000, 3300,
 };
 
-const static int ldo123_voltage_map[] = {
+static const int ldo123_voltage_map[] = {
 	1800, 1900, 2000, 2100, 2200, 2300, 2400, 2500,
 	2600, 2700, 2800, 2900, 3000, 3100, 3200, 3300,
 };
 
-const static int *ldo_voltage_map[] = {
+static const int *ldo_voltage_map[] = {
 	ldo123_voltage_map, /* LDO1 */
 	ldo123_voltage_map, /* LDO2 */
 	ldo123_voltage_map, /* LDO3 */
-- 
1.6.3.3

