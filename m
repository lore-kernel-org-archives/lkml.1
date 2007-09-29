Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbXI2KZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbXI2KZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 06:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXI2KZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 06:25:33 -0400
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:63093 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751294AbXI2KZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 06:25:32 -0400
Date: Sat, 29 Sep 2007 12:25:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: [PATCH] CodingStyle: Printing numbers in parentheses is fine
Message-ID: <20070929122530.5c45f743@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a not particularly relevant rule from CodingStyle.
Sometimes, printing numbers in parentheses doesn't add value, but in
some (most?) cases it makes the message easier to read. As a matter of
fact, this practice is widely used in the kernel:

linux-2.6.23-rc8$ quilt grep -I '(%l*[du])' | wc -l
3166
linux-2.6.23-rc8$

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 Documentation/CodingStyle |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.23-rc8.orig/Documentation/CodingStyle	2007-07-23 16:44:32.000000000 +0200
+++ linux-2.6.23-rc8/Documentation/CodingStyle	2007-09-28 23:53:23.000000000 +0200
@@ -638,8 +638,6 @@ concise, clear, and unambiguous.
 
 Kernel messages do not have to be terminated with a period.
 
-Printing numbers in parentheses (%d) adds no value and should be avoided.
-
 There are a number of driver model diagnostic macros in <linux/device.h>
 which you should use to make sure messages are matched to the right device
 and driver, and are tagged with the right level:  dev_err(), dev_warn(),


-- 
Jean Delvare
