Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbXDDG3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbXDDG3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992700AbXDDG2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:28:25 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:10425 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992706AbXDDG2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:28:15 -0400
X-IronPort-AV: i="4.14,367,1170651600"; 
   d="scan'208"; a="26306158:sNHT20709199"
Subject: [PATCH] blackfin arch: use boot_command_line instead of
	save_command_line in setup c file
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 04 Apr 2007 14:28:23 +0800
Message-Id: <1175668103.10608.39.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index ce51882..9870c60 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -221,7 +221,7 @@ void __init setup_arch(char **cmdline_p)
 
 	/* Keep a copy of command line */
 	*cmdline_p = &command_line[0];
-	memcpy(saved_command_line, command_line, COMMAND_LINE_SIZE);
+	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	saved_command_line[COMMAND_LINE_SIZE - 1] = 0;
 
 	/* setup memory defaults from the user config */
-- 
1.5.0.5

