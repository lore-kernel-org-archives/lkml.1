Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYK0VCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYK0VCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 16:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYK0VCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 16:02:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:33400 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYK0VCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 16:02:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=npvOSk7Ny/aKq+HbEQLtAwFJRqIZ68bsI8wZmR9jtdz1JDkiQBt4Yd3MxMaur1fynx
         he/hjYZDdQEsynii5RsX+ZaBljDgsQNxwJxd2HJ+Vvod18RnfX7y5fbFAh9Nmedk/RZz
         n3qWnMoJok5mgOzgfjrJNGjWNDwZre+2hRI6Q=
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: [PATCH] [STAGING] Move staging drivers back to staging-specific menu
Date: Fri, 28 Nov 2008 00:01:28 +0300
Message-Id: <1227819688-24035-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/staging/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index c95b286..4089f14 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -22,6 +22,8 @@ menuconfig STAGING
 	  If in doubt, say N here.
 
 
+if STAGING
+
 config STAGING_EXCLUDE_BUILD
 	bool "Exclude Staging drivers from being built" if STAGING
 	default y
@@ -37,8 +39,6 @@ config STAGING_EXCLUDE_BUILD
 	  when selecting 'make allyesconfg' and 'make allmodconfig' so
 	  don't be all that put off, your dog will be just fine.
 
-if !STAGING_EXCLUDE_BUILD
-
 source "drivers/staging/et131x/Kconfig"
 
 source "drivers/staging/slicoss/Kconfig"
-- 
1.5.6.5

