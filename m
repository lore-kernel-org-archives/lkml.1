Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbZFTSuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbZFTSuv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbZFTSr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:47:26 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48196 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758249AbZFTSrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:47:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 22/25] Blackfin: drop unused ISP1760 port1_disable from board resources
Date: Sat, 20 Jun 2009 14:44:45 -0400
Message-Id: <1245523488-26536-23-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The port1 disable stuff was dropped from the USB ISP1760, so update the
Blackfin boards accordingly.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf527/boards/cm_bf527.c |    1 -
 arch/blackfin/mach-bf527/boards/ezkit.c    |    1 -
 arch/blackfin/mach-bf537/boards/stamp.c    |    1 -
 arch/blackfin/mach-bf548/boards/ezkit.c    |    1 -
 arch/blackfin/mach-bf561/boards/ezkit.c    |    1 -
 5 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index 1eaf27f..f4867ce 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -78,7 +78,6 @@ static struct resource bfin_isp1760_resources[] = {
 
 static struct isp1760_platform_data isp1760_priv = {
 	.is_isp1761 = 0,
-	.port1_disable = 0,
 	.bus_width_16 = 1,
 	.port1_otg = 0,
 	.analog_oc = 0,
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index 3e5b7db..799a1d1 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -77,7 +77,6 @@ static struct resource bfin_isp1760_resources[] = {
 
 static struct isp1760_platform_data isp1760_priv = {
 	.is_isp1761 = 0,
-	.port1_disable = 0,
 	.bus_width_16 = 1,
 	.port1_otg = 0,
 	.analog_oc = 0,
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index ff7228c..c1f76dd 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -79,7 +79,6 @@ static struct resource bfin_isp1760_resources[] = {
 
 static struct isp1760_platform_data isp1760_priv = {
 	.is_isp1761 = 0,
-	.port1_disable = 0,
 	.bus_width_16 = 1,
 	.port1_otg = 0,
 	.analog_oc = 0,
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 805a57b..81f5b95 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -76,7 +76,6 @@ static struct resource bfin_isp1760_resources[] = {
 
 static struct isp1760_platform_data isp1760_priv = {
 	.is_isp1761 = 0,
-	.port1_disable = 0,
 	.bus_width_16 = 1,
 	.port1_otg = 0,
 	.analog_oc = 0,
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index b5ef7ff..4df904f 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -62,7 +62,6 @@ static struct resource bfin_isp1760_resources[] = {
 
 static struct isp1760_platform_data isp1760_priv = {
 	.is_isp1761 = 0,
-	.port1_disable = 0,
 	.bus_width_16 = 1,
 	.port1_otg = 0,
 	.analog_oc = 0,
-- 
1.6.3.1

