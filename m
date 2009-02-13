Return-Path: <linux-kernel-owner+w=401wt.eu-S1761679AbZBMPAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761679AbZBMPAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 10:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbZBMPAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 10:00:32 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:55648 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbZBMPAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:00:31 -0500
X-BigFish: VPS1(z5edJzzzzzz32i6bh43j)
X-WSS-ID: 0KF0F0D-02-JES-01
Date: Fri, 13 Feb 2009 16:00:06 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] x86: update description for memtest boot parameter
Message-ID: <20090213150006.GG13000@alberich.amd.com>
References: <20090213144600.GA6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090213144600.GA6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Feb 2009 15:00:17.0010 (UTC) FILETIME=[C8101D20:01C98DEB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 Documentation/kernel-parameters.txt |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b182626..a59c71d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1308,8 +1308,13 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	memtest=	[KNL,X86] Enable memtest
 			Format: <integer>
-			range: 0,4 : pattern number
 			default : 0 <disable>
+			Specifies the number of memtest passes to be
+			performed. Each pass selects another test
+			pattern from a given set of patterns. Memtest
+			fills the memory with this pattern, validates
+			memory contents and reserves bad memory
+			regions that are detected.
 
 	meye.*=		[HW] Set MotionEye Camera parameters
 			See Documentation/video4linux/meye.txt.
-- 
1.6.1.2



