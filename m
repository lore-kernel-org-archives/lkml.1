Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYEDSgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYEDSgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYEDSga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:36:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:23803 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbYEDSg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:36:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=GpS8gLJIOUZC+oaTZaZ9QjiF+TuJP8SfAhG+m2RfMyD4nXfpKFZWOHGHUL0cyysJakmaZVKXIEz3i3XKJI7W2qNVq58Kr+q5jqsgsQ0Ox2nL7qJN4FdkYxsSpj8uwXaSCbQBMtbuP7JNn1b9en5YiWIIRjOBf5nAyOxG53DWI4I=
Date: Mon, 5 May 2008 00:06:16 +0530
From: Pradeep Singh Rautela <rautelap@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, chas@cmf.nrl.navy.mil, rautelap@gmail.com
Subject: [PATCH] eni: Remove unused macro KERNEL_OFFSET from eni.h
Message-ID: <20080504183616.GA13357@kernelpanic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eni.h is used only by eni.c and it does not uses KERNEL_OFFSET anywhere.
Remove KERNEL_OFFSET macro from the eni.h header file.

Signed-off-by: Pradeep Singh <rautelap@gmail.com>
---
 drivers/atm/eni.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/eni.h b/drivers/atm/eni.h
index d04fefb..e4c9525 100644
--- a/drivers/atm/eni.h
+++ b/drivers/atm/eni.h
@@ -18,7 +18,6 @@
 #include "midway.h"
 
 
-#define KERNEL_OFFSET	0xC0000000	/* kernel 0x0 is at phys 0xC0000000 */
 #define DEV_LABEL	"eni"
 
 #define UBR_BUFFER	(128*1024)	/* UBR buffer size */
-- 
1.5.5.1

