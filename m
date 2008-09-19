Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbYISGqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbYISGqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 02:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbYISGqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 02:46:04 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:27866 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbYISGqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 02:46:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TQdKdjh0o9CLE40c6EVQAK1FYi18n9pqk2F7Bkce62zUOlXKex4PQXiGIFMbb2oBOl
         2RUYp3/zqIiEGeLfFtJ1xf+7yTjHCJTVTmyPOk/K0SRGrGHnnS8tmuia0ovF1jFh/ge1
         Q3uIg7Ow0q5ZfeJPEr+umxTNo7YrRoPQtR0CM=
Message-ID: <bd2d05340809182345k63cacc8hf9683ff53765424a@mail.gmail.com>
Date: Fri, 19 Sep 2008 01:45:58 -0500
From: "David Almaroad" <dalmaroad@gmail.com>
To: mdharm-usb@one-eyed-alien.net
Subject: [PATCH 1/1] USB: Unusual devs patch for Nokia 5310 Music Xpress
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From David Almaroad <dalmaroad@gmail.com>

The Nokia 5310 Music Xpress phone reports one too many sectors in
usb-storage mode. This patch resolves that.

Signed-off-by: David Almaroad <dalmaroad@gmail.com>
---

--- a/drivers/usb/storage/unusual_devs.h    2008-09-10 07:49:40.000000000 -0500
+++ b/drivers/usb/storage/unusual_devs.h    2008-09-17 01:48:35.000000000 -0500
@@ -232,6 +232,13 @@
         US_SC_DEVICE, US_PR_DEVICE, NULL,
         US_FL_FIX_CAPACITY ),

+/* Patch for Nokia 5310 capacity */
+UNUSUAL_DEV(  0x0421, 0x006a, 0x0000, 0x0591,
+        "Nokia",
+        "5310",
+        US_SC_DEVICE, US_PR_DEVICE, NULL,
+        US_FL_FIX_CAPACITY ),
+
 /* Reported by Olaf Hering <olh@suse.de> from novell bug #105878 */
 UNUSUAL_DEV(  0x0424, 0x0fdc, 0x0210, 0x0210,
         "SMSC",
