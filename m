Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbYJVRds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbYJVRds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbYJVRcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:32:50 -0400
Received: from kroah.org ([198.145.64.141]:53005 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753877AbYJVRcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:32:48 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/42] linux-next: build failure
Date: Wed, 22 Oct 2008 10:28:44 -0700
Message-Id: <1224696563-5170-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

sxghif.h has code that explicitly will not build fo other architecures.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/sxg/README |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/sxg/README b/drivers/staging/sxg/README
index 4d1ddbe..d514d18 100644
--- a/drivers/staging/sxg/README
+++ b/drivers/staging/sxg/README
@@ -7,6 +7,7 @@ TODO:
 	- remove wrappers
 	- checkpatch.pl cleanups
 	- new functionality that the card needs
+	- remove reliance on x86
 
 Please send patches to:
         Greg Kroah-Hartman <gregkh@suse.de>
-- 
1.6.0.2

