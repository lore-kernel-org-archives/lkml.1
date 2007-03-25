Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbXCYP6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbXCYP6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 11:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbXCYP6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 11:58:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:62700 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbXCYP6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 11:58:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=YBTZ4nEvB9WKxiFpAQJ8aKZCN2DZvFDJQCYqQr8CosDU7u2+AFXVOBIVF5Qp4PZGFU943zI9A121N2KMVrfV9c0JzbwHYVBtkGRjlSEr51aRkJk3uS4rWvvuLsaG6OB7EiViOPS52FbMcTzsNs7QeKQnkj85+tDhgQyhzFnQSeA=
Message-ID: <46069C10.7060801@googlemail.com>
Date: Sun, 25 Mar 2007 17:58:08 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] drivers/char/ip2/i2ellis.c remove unused function
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unused function

CC      drivers/char/ip2/ip2main.o
drivers/char/ip2/i2ellis.c:108: warning: ‘iiEllisCleanup’ defined but not used

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work5/drivers/char/ip2/i2ellis.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-work3/drivers/char/ip2/i2ellis.c	2007-03-25 01:06:37.000000000 +0100
@@ -93,23 +93,6 @@ iiEllisInit(void)
 }
 
 //******************************************************************************
-// Function:   iiEllisCleanup()
-// Parameters: None
-//
-// Returns:    Nothing
-//
-// Description:
-//
-// This routine performs any required cleanup of the iiEllis subsystem.
-//
-//******************************************************************************
-static void
-iiEllisCleanup(void)
-{
-	kfree(pDelayTimer);
-}
-
-//******************************************************************************
 // Function:   iiSetAddress(pB, address, delay)
 // Parameters: pB      - pointer to the board structure
 //             address - the purported I/O address of the board
