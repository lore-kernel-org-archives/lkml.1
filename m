Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbXGKSjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbXGKSjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761582AbXGKSiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:38:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:16624 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760389AbXGKSit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=CScp3ExTVTT+baaYzevflAuL01vh1fpSpLnKwce8Fxc3lzz56oUs5aKvZLeW+ZWcBKcqQKhhPSo/UU41qDdUbObB+q1vGVYqrCyerDmcxT8036mzaZa80ebC4yrvb65+ludN2aB4rTZRqf95zRs4b2TdJdYkETQ7SCtO9eStqgM=
Date: Wed, 11 Jul 2007 22:38:41 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] Sky Cpu and Nexus: get rid of useless NULL init
Message-ID: <20070711183841.GA7157@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes useless structure items init accroding to C99.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/hdpuftrs/hdpu_cpustate.c b/drivers/misc/hdpuftrs/hdpu_cpustate.c
index cc33f24..427e357 100644
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c
+++ b/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -176,9 +176,6 @@ static const struct file_operations cpustate_fops = {
       .release	= cpustate_release,
       .read	= cpustate_read,
       .write	= cpustate_write,
-      .fasync	= NULL,
-      .poll	= NULL,
-      .ioctl	= NULL,
       .llseek	= no_llseek,
 };
 
