Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0CCSYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:24:08 -0500
Received: from [206.15.93.42] ([206.15.93.42]:16983 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755300Ab0CCSYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:24:07 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging/dt3155: fix build error caused by {write|read}l change
Date: Wed, 3 Mar 2010 11:24:06 -0700
Cc: greg@kroah.com, ss@aao.gov.au
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003031124.06345.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a build error caused by replacing {Write | Read}MReg with 
{write | read}l.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_io.c b/drivers/staging/dt3155/dt3155_io.c
index 6b9c685..3df2ec7 100644
--- a/drivers/staging/dt3155/dt3155_io.c
+++ b/drivers/staging/dt3155/dt3155_io.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/io.h>
 #include "dt3155.h"
 #include "dt3155_io.h"
 #include "dt3155_drv.h"
