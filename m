Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbYF3OT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbYF3OT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 10:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYF3OTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 10:19:48 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:59262 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751652AbYF3OTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 10:19:47 -0400
Subject: MMC: Fix typo in struct mmc_host_ops get_cd documentation
Message-Id: <20080630141945.494429513@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@dzezus.cx, Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-mmc-fix-hostops-typo.patch
Date: Mon, 30 Jun 2008 15:19:45 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation in 'struct mmc_host_ops' references .get_ro
twice, where the second reference should be to the .get_cd
field.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/include/linux/mmc/host.h
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/include/linux/mmc/host.h	2008-06-30 15:13:10.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/include/linux/mmc/host.h	2008-06-30 15:13:18.000000000 +0100
@@ -65,7 +65,7 @@ struct mmc_host_ops {
 	 *   -ENOSYS when not supported (equal to NULL callback)
 	 *   or a negative errno value when something bad happened
 	 *
-	 * Return values for the get_ro callback should be:
+	 * Return values for the get_cd callback should be:
 	 *   0 for a absent card
 	 *   1 for a present card
 	 *   -ENOSYS when not supported (equal to NULL callback)

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
