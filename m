Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbZDOIwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbZDOIwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZDOIwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:52:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38089 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbZDOIwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:52:36 -0400
Date: Wed, 15 Apr 2009 16:52:22 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, eugeneteo@kernel.sg
Subject: [PATCH] regulator: remove extraneous semicolon
Message-ID: <20090415085222.GA12942@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An extraneous ";" after the if statement is a bad idea.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 drivers/regulator/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 01f7702..47fc6e6 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -540,8 +540,8 @@ static void drms_uA_update(struct regulator_dev *rdev)
 
 	err = regulator_check_drms(rdev);
 	if (err < 0 || !rdev->desc->ops->get_optimum_mode ||
-	    !rdev->desc->ops->get_voltage || !rdev->desc->ops->set_mode);
-	return;
+	    !rdev->desc->ops->get_voltage || !rdev->desc->ops->set_mode)
+		return;
 
 	/* get output voltage */
 	output_uV = rdev->desc->ops->get_voltage(rdev);
