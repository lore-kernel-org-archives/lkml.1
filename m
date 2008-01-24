Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbYAXQ6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbYAXQ6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbYAXQxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:23 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64226 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbYAXQxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:04 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 10/17] [MIPS] Malta: remove a superfluous comment
Date: Thu, 24 Jan 2008 19:52:50 +0300
Message-Id: <1201193577-4261-11-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the "We die here" comment right before calling the die()
function is an extremely vivid example of overcommenting.

Remove the redundant comment and save one line.

No functional changes introduced.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_int.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_int.c b/arch/mips/mips-boards/malta/malta_int.c
index 41eb232..a268912 100644
--- a/arch/mips/mips-boards/malta/malta_int.c
+++ b/arch/mips/mips-boards/malta/malta_int.c
@@ -173,7 +173,6 @@ static void corehi_irqdispatch(void)
 		break;
 	}
 
-	/* We die here*/
 	die("CoreHi interrupt", regs);
 }
 
-- 
1.5.3

