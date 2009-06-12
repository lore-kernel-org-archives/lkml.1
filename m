Return-Path: <linux-kernel-owner+w=401wt.eu-S1763194AbZFLJFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763194AbZFLJFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759285AbZFLJFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:05:32 -0400
Received: from mout3.freenet.de ([195.4.92.93]:37938 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbZFLJFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:05:32 -0400
Message-ID: <4A321A3C.6030400@gmx.de>
Date: Fri, 12 Jun 2009 11:05:00 +0200
From: Patrick Ringl <patrick.ringl@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@osdl.org
Subject: PATCH: README - Fix misleading pointer to the defconf directory
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the README simply points to a wrong/non-existent directory where the default configurations are not suited, hence the patch.


Signed-off-by: Patrick Ringl <patrick_@freenet.de>

-----

--- linux.orig/README	2009-06-10 05:05:27.000000000 +0200
+++ linux/README	2009-06-12 10:46:15.000000000 +0200
@@ -175,7 +175,7 @@
 			   Like above, but avoids cluttering the screen
 			   with questions already answered.
 	"make defconfig"   Create a ./.config file by using the default
-			   symbol values from arch/$ARCH/defconfig.
+			   symbol values from arch/$ARCH/configs/*_defconfig.
 	"make allyesconfig"
 			   Create a ./.config file by setting symbol
 			   values to 'y' as much as possible.

-----


regards,
Patrick

