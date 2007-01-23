Return-Path: <linux-kernel-owner+w=401wt.eu-S932995AbXAWMZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbXAWMZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 07:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932998AbXAWMZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 07:25:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60924 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932995AbXAWMZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 07:25:09 -0500
To: torvalds@osdl.org
Subject: [PATCH] horizon.c: missing __devinit
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1H9Ki4-0006p7-FI@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 23 Jan 2007 12:25:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/atm/horizon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index 4dc1010..f96446c 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -1845,7 +1845,7 @@ static u16 __devinit read_bia (const hrz
 
 /********** initialise a card **********/
 
-static int __init hrz_init (hrz_dev * dev) {
+static int __devinit hrz_init (hrz_dev * dev) {
   int onefivefive;
   
   u16 chan;
-- 
1.4.2.GIT

