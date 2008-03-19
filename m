Return-Path: <linux-kernel-owner+w=401wt.eu-S1765065AbYCSVOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765065AbYCSVOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761942AbYCST7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:59:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36153 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761900AbYCST7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:59:33 -0400
Date: Wed, 19 Mar 2008 15:24:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Document memmap option better
Message-ID: <20080319142427.GA25627@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Provide example for memmap exclude option (it is slightly strange an
non-trivial) and provide nice small HOWTO for people with bad
memory.

Signed-off-by: Jan-Simon Moeller <dl9pf@gmx.de>
Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 622f784..467034c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1128,6 +1128,10 @@ and is between 256 and 4096 characters. 
 	memmap=nn[KMG]$ss[KMG]
 			[KNL,ACPI] Mark specific memory as reserved.
 			Region of memory to be used, from ss to ss+nn.
+			Example: Exclude memory from 0x18690000-0x1869ffff
+			         memmap=64K$0x18690000
+			         or
+			         memmap=0x10000$0x18690000
 
 	meye.*=		[HW] Set MotionEye Camera parameters
 			See Documentation/video4linux/meye.txt.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
