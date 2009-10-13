Return-Path: <linux-kernel-owner+w=401wt.eu-S934435AbZJMWB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934435AbZJMWB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZJMWBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:01:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:62023 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939AbZJMWBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:01:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mbUQPC6w5JtaGVXLA+xpZ3DYGEpvmidNZ6PY7oVViSuWdG+VEAOmbKl7+SjuNOj73d
         LCaNzAFy8SPupcoW5yG1BODeLfqxlXm//rnu7zgLUcak7ynD19mwflZQtcG7EOZtaQbv
         vnlkuzAGHkCOB0HGan/YldfgzkZZDPQApwxuw=
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Nelson Castillo <arhuaco@freaks-unidos.net>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH] gta02: set pcf50633 chg_ref_current_ma
Date: Wed, 14 Oct 2009 01:59:05 +0400
Message-Id: <1255471148-29047-3-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255471148-29047-2-git-send-email-fercerpav@gmail.com>
References: <1255471148-29047-1-git-send-email-fercerpav@gmail.com>
 <1255471148-29047-2-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

This value is board-specific and is needed for calculations to set charging
current limit properly.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Nelson Castillo <arhuaco@freaks-unidos.net>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---

Since this patch compile-depends on previous probably it should go through
the same tree as others. Nelson (gta02 maintainer) agrees with whatever you
think is best.

 arch/arm/mach-s3c2442/mach-gta02.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2442/mach-gta02.c b/arch/arm/mach-s3c2442/mach-gta02.c
index 0fb385b..b0a3d74 100644
--- a/arch/arm/mach-s3c2442/mach-gta02.c
+++ b/arch/arm/mach-s3c2442/mach-gta02.c
@@ -268,6 +268,9 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
 
 	.batteries = gta02_batteries,
 	.num_batteries = ARRAY_SIZE(gta02_batteries),
+
+	.chg_ref_current_ma = 1000,
+
 	.reg_init_data = {
 		[PCF50633_REGULATOR_AUTO] = {
 			.constraints = {
-- 
1.6.0.6

