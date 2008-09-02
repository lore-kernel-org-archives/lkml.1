Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYIBIYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYIBIYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 04:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYIBIYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 04:24:32 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:32944 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbYIBIYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 04:24:31 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Sep 2008 04:24:30 EDT
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org, michael@free-electrons.com,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH 1/1] [mmc] Fix comment in include/linux/mmc/host.h
Date: Tue,  2 Sep 2008 10:14:13 +0200
Message-Id: <1220343253-18681-1-git-send-email-thomas.petazzoni@free-electrons.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In include/linux/mmc/host.h, it is mentionned that the callback to
know if a card is present or not is get_ro(). But it's get_cd().

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 include/linux/mmc/host.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 9c288c9..bde891f 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
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
1.5.4.3

