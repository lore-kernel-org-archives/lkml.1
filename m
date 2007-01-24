Return-Path: <linux-kernel-owner+w=401wt.eu-S965531AbXAYGcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965531AbXAYGcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 01:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965547AbXAYGcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 01:32:04 -0500
Received: from mailout05.sul.t-online.com ([194.25.134.82]:45449 "EHLO
	mailout05.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965546AbXAYGcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 01:32:01 -0500
X-Greylist: delayed 50430 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 01:32:01 EST
Message-Id: <6.1.1.1.2.20070124172600.04f40dc8@192.168.6.12>
X-Mailer: QUALCOMM Windows Eudora Version 6.1.1.1
Date: Wed, 24 Jan 2007 17:30:59 +0100
To: linux-kernel@vger.kernel.org
From: Roger While <simrw@sim-basis.de>
Subject: [PATCH] gpu/radeonfb: add GPU support to radeonfb
Cc: airlied@linux.ie, benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
X-SIMBasis-MailScanner-Information: Please contact the ISP for more information
X-SIMBasis-MailScanner: Found to be clean
X-SIMBasis-MailScanner-From: simrw@sim-basis.de
X-ID: rSe2WuZLweiSyFXZ-bFBHTk-DK0iGy772AccM72DOt7VqeEWD4Jcgw@t-dialin.net
X-TOI-MSGID: 4581106c-bc60-4102-abeb-2fcfeb8efeab
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

@@ -241,9 +241,9 @@ void radeonfb_engine_reset(struct radeon
  	INREG(HOST_PATH_CNTL);
  	OUTREG(HOST_PATH_CNTL, host_path_cntl);

-	if (rinfo->family != CHIP_FAMILY_R300 ||
-	    rinfo->family != CHIP_FAMILY_R350 ||
-	    rinfo->family != CHIP_FAMILY_RV350)
+	if (rinfo->gpu_info->family != CHIP_FAMILY_R300 ||
+	    rinfo->gpu_info->family != CHIP_FAMILY_R350 ||
+	    rinfo->gpu_info->family != CHIP_FAMILY_RV350)
  		OUTREG(RBBM_SOFT_RESET, rbbm_soft_reset);

Alarm bells going off - "!=" combined with "||" ?
Looks like a reset will always be done.

Roger While


