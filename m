Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbZJVPbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbZJVPbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbZJVPbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:31:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41214 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756522AbZJVPbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:31:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/6] regulator: Remove duplicate consts from ab3100
Date: Thu, 22 Oct 2009 16:31:34 +0100
Message-Id: <1256225495-15379-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1256225495-15379-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1256225495-15379-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'static const int const' means the same thing as 'static const int'
and sparse complains about this.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/ab3100.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 49aeee8..5da127b 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -81,7 +81,7 @@ static const u8 ab3100_reg_init_order[AB3100_NUM_REGULATORS+2] = {
 #define LDO_C_VOLTAGE 2650000
 #define LDO_D_VOLTAGE 2650000
 
-static const int const ldo_e_buck_typ_voltages[] = {
+static const int ldo_e_buck_typ_voltages[] = {
 	1800000,
 	1400000,
 	1300000,
@@ -91,7 +91,7 @@ static const int const ldo_e_buck_typ_voltages[] = {
 	900000,
 };
 
-static const int const ldo_f_typ_voltages[] = {
+static const int ldo_f_typ_voltages[] = {
 	1800000,
 	1400000,
 	1300000,
@@ -102,21 +102,21 @@ static const int const ldo_f_typ_voltages[] = {
 	2650000,
 };
 
-static const int const ldo_g_typ_voltages[] = {
+static const int ldo_g_typ_voltages[] = {
 	2850000,
 	2750000,
 	1800000,
 	1500000,
 };
 
-static const int const ldo_h_typ_voltages[] = {
+static const int ldo_h_typ_voltages[] = {
 	2750000,
 	1800000,
 	1500000,
 	1200000,
 };
 
-static const int const ldo_k_typ_voltages[] = {
+static const int ldo_k_typ_voltages[] = {
 	2750000,
 	1800000,
 };
-- 
1.6.5

