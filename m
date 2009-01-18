Return-Path: <linux-kernel-owner+w=401wt.eu-S1764789AbZARKDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764789AbZARKDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 05:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZARKDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 05:03:31 -0500
Received: from server78.greatnet.de ([83.133.96.102]:53247 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZARKDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 05:03:30 -0500
X-Greylist: delayed 1379 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Jan 2009 05:03:29 EST
Message-ID: <4972F908.7010800@nachtwindheim.de>
Date: Sun, 18 Jan 2009 10:40:24 +0100
From: Henne <henne@nachtwindheim.de>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jaroslav Kysela <perex@suse.cz>
CC: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] Remove removed OSS kernel parameters from doc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

Remove removed OSS kernel parameters from kernel-parameters.txt

Remove the kernel parameters from the OSS drivers of the chips
es1371 (removed 10-2007/2.6.24) and
cs4232 (removed 02-2008/2.6.25) from the kernel parameters documentation.

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 8511d35..d8362cf 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -577,9 +577,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			a memory unit (amount[KMG]). See also
 			Documentation/kdump/kdump.txt for a example.
 
-	cs4232=		[HW,OSS]
-			Format: <io>,<irq>,<dma>,<dma2>,<mpuio>,<mpuirq>
-
 	cs89x0_dma=	[HW,NET]
 			Format: <dma>
 
@@ -732,10 +729,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			Default value is 0.
 			Value can be changed at runtime via /selinux/enforce.
 
-	es1371=		[HW,OSS]
-			Format: <spdif>,[<nomix>,[<amplifier>]]
-			See also header of sound/oss/es1371.c.
-
 	ether=		[HW,NET] Ethernet cards parameters
 			This option is obsoleted by the "netdev=" option, which
 			has equivalent usage. See its documentation for details.


