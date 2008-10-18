Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897AbYJRNP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbYJRNP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 09:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYJRNPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 09:15:18 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:45261 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYJRNPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 09:15:17 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Jurgen Schindele <linux@schindele.name>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm: remove extra brace in arch/arm/mach-pxa/trizeps4.c
Date: Sat, 18 Oct 2008 15:15:16 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810181515.17231.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Introduced by:

commit 642aa6637e46ae788f1f8916dc9aa5a68917e12e
Author: J<C3><BC>rgen Schindele <linux@schindele.name>
Date:   Mon Aug 18 21:45:03 2008 +0100

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

--- a/arch/arm/mach-pxa/trizeps4.c
+++ b/arch/arm/mach-pxa/trizeps4.c
@@ -399,7 +399,7 @@ static void trizeps4_irda_transceiver_mode(struct device *dev, int mode)
 	/* Switch mode */
 	if (mode & IR_SIRMODE)
 		trizeps_conxs_ircr &= ~ConXS_IRCR_MODE;	/* Slow mode */
-	else if (mode & IR_FIRMODE) {
+	else if (mode & IR_FIRMODE)
 		trizeps_conxs_ircr |= ConXS_IRCR_MODE;	/* Fast mode */

 	/* Switch power */
