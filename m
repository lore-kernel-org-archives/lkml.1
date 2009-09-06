Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbZIFRea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbZIFRea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 13:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757310AbZIFRe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 13:34:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49066 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034AbZIFRe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 13:34:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 6 Sep 2009 19:34:17 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: remove a workaround for Momobay FX-3A
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.6c11001dd6cbaffc@s5r6.in-berlin.de>
Message-ID: <tkrat.eedf5bae12db5d9e@s5r6.in-berlin.de>
References: <tkrat.6c11001dd6cbaffc@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inquiry delay is not necessary anymore in tests on a recent kernel.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.31-rc9/drivers/ieee1394/sbp2.c
===================================================================
--- linux-2.6.31-rc9.orig/drivers/ieee1394/sbp2.c
+++ linux-2.6.31-rc9/drivers/ieee1394/sbp2.c
@@ -372,8 +372,7 @@ static const struct {
 	/* DViCO Momobay FX-3A with TSB42AA9A bridge */ {
 		.firmware_revision	= 0x002800,
 		.model			= 0x000000,
-		.workarounds		= SBP2_WORKAROUND_DELAY_INQUIRY |
-					  SBP2_WORKAROUND_POWER_CONDITION,
+		.workarounds		= SBP2_WORKAROUND_POWER_CONDITION,
 	},
 	/* Initio bridges, actually only needed for some older ones */ {
 		.firmware_revision	= 0x000200,

-- 
Stefan Richter
-=====-==--= =--= --==-
http://arcgraph.de/sr/

