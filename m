Return-Path: <linux-kernel-owner+w=401wt.eu-S1763539AbYENUK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763539AbYENUK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760876AbYENUKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:10:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:52458 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759316AbYENUKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=wM6kEwlXITZI6+6oArlPkuWJY1k6OaxqDlW7N6OGv7u0HuWCoXUBf0OAwemoNOThK5mYnw+3UTEqKun0bBweXa/ryduTcjKCrouZNyNcMlRSdMzCH+hQqYD2mSq8XskIAIKWCZQkfIisbMV/2uxmMYeggjNbZmX0MrKnqSd00dU=
Date: Thu, 15 May 2008 01:40:06 +0530
From: Pradeep Singh Rautela <rautelap@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 2.6.26-rc2] driver:Remove unused macro KERNEL_OFFSET
Message-ID: <20080514201006.GD7338@kernelpanic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

KERNEL_OFFSET macro in eni.h is not required as it is not used anywhere.
Remove the unused macro from eni.h header file.

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

