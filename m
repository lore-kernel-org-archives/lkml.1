Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbYFTMwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbYFTMwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 08:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYFTMv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 08:51:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:53734 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbYFTMvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 08:51:54 -0400
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andre Haupt <andre@bitwigglers.org>
Subject: [PATCH 1/2] parport: remove superfluous local variable.
Date: Fri, 20 Jun 2008 14:51:44 +0200
Message-Id: <15ef717cf17bfbbcdd49599ed9c99cc655b610fa.1213965527.git.andre@bitwigglers.org>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <cover.1213965527.git.andre@bitwigglers.org>
References: <cover.1213965527.git.andre@bitwigglers.org>
In-Reply-To: <cover.1213965527.git.andre@bitwigglers.org>
References: <cover.1213965527.git.andre@bitwigglers.org>
X-Provags-ID: V01U2FsdGVkX19Irh6Ffd+hQm112NFHFK/2I0lejjGEOrM27W1
 aNlPHxPSwL5lb1ZblnuXSDlPEcYW5oQ6CfdNjJU3dSIkZxa77h
 olpxaTthOT5ilrojgZQYfrhrPJajan0NWhWTqLPMZ8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
---
 drivers/parport/ieee1284.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/parport/ieee1284.c b/drivers/parport/ieee1284.c
index 0338b09..e970594 100644
--- a/drivers/parport/ieee1284.c
+++ b/drivers/parport/ieee1284.c
@@ -199,8 +199,6 @@ int parport_wait_peripheral(struct parport *port,
 	/* 40ms of slow polling. */
 	deadline = jiffies + msecs_to_jiffies(40);
 	while (time_before (jiffies, deadline)) {
-		int ret;
-
 		if (signal_pending (current))
 			return -EINTR;
 
-- 
1.5.5.GIT

