Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYABLnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYABLnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 06:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYABLno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 06:43:44 -0500
Received: from cvs.mpc-ogw.co.uk ([81.2.99.171]:1361 "EHLO
	molson.mpc-data.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752056AbYABLnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 06:43:43 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] sh: sh7712 defconfig
Date: Wed, 2 Jan 2008 11:43:39 -0000
Message-ID: <0C997DD87CC88A4F86C897F52650B52B820E95@MOLSON.mpc-data.co.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] sh: sh7712 defconfig
Thread-Index: AchLyrpP8ZlwI+8FRzmQcVdtMnkC2QBaG3jQ
From: "Andrew Murray" <amurray@mpc-data.co.uk>
To: <lethal@linux-sh.org>
Cc: <linux-sh@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Murray <amurray@mpc-data.co.uk>

This patch provides a correct value for CONFIG_SH_PCLK_FREQ for the SH7712 solution engine when used with the board's default factory settings. This results in the board running at its maximum CPU clock rate (200 MHz).

The board I have is a Japanese Solution Engine with a 66 MHz (extal) crystal. Is this the only variant of the Solution Engine for the SH7712?

Signed-off-by: Andrew Murray <amurray@mpc-data.co.uk>
---
diff -uprN -X sh-2.6/Documentation/dontdiff sh-2.6/arch/sh/configs/se7712_defconfig sh-2.6-devel/arch/sh/configs/se7712_defconfig
--- sh-2.6/arch/sh/configs/se7712_defconfig     2008-01-02 10:13:44.000000000 +0000
+++ sh-2.6-devel/arch/sh/configs/se7712_defconfig       2008-01-02 10:28:32.000000000 +0000
@@ -237,7 +237,7 @@ CONFIG_CPU_HAS_SR_RB=y
 CONFIG_SH_TMU=y
 CONFIG_SH_TIMER_IRQ=16
 # CONFIG_NO_IDLE_HZ is not set
-CONFIG_SH_PCLK_FREQ=33333333
+CONFIG_SH_PCLK_FREQ=66666666

 #
 # CPU Frequency scaling

Internal Virus Database is out-of-date.
Checked by AVG Free Edition. 
Version: 7.5.516 / Virus Database: 269.17.8 - Release Date: 24/12/2007 00:00
 
