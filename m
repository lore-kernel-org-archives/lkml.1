Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbXFCOli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbXFCOli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXFCOkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:40:11 -0400
Received: from web50105.mail.re2.yahoo.com ([206.190.38.33]:45982 "HELO
	web50105.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751976AbXFCOkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:40:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=cyUA6UPqyVsfIR0vJCxmMG06PUpA9h6fvPEvEq+Mx7ot4ztO9PbaiAtrfw1B9fWY+6kXyl0GQPefqQ5tBc+/XZ8yJ0qnHOe3XMbug/yd20Uq+ydEX5UqJ/Vjf+zFxckhopjsj6wr2HpuIrgF92atE19yMj86rhB47/e+j/FLdVM=;
X-YMail-OSG: NF7qhtkVM1kcSOM5B5.1NaptXm0F8C9Gum.4E6MOhl1WL2aNCDV_av7zjtZmCJPKanCn_A--
Date: Sun, 3 Jun 2007 07:40:07 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 7/36] drivers edac add mc sysfs missing mem types
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <925027.80419.qm@web50105.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Dave Jiang <djiang@mvista.com>

Adding missing mem types for use in the sysfs presentation file for
Memory Controller device objects.

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>

---
 edac_mc_sysfs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)
---

Index: linux-mm/drivers/edac/edac_mc_sysfs.c
===================================================================
--- linux-mm.orig/drivers/edac/edac_mc_sysfs.c
+++ linux-mm/drivers/edac/edac_mc_sysfs.c
@@ -67,7 +67,10 @@ static const char *mem_types[] = {
 	[MEM_RDR] = "Registered-SDR",
 	[MEM_DDR] = "Unbuffered-DDR",
 	[MEM_RDDR] = "Registered-DDR",
-	[MEM_RMBS] = "RMBS"
+	[MEM_RMBS] = "RMBS",
+	[MEM_DDR2] = "Unbuffered-DDR2",
+	[MEM_FB_DDR2] = "FullyBuffered-DDR2",
+	[MEM_RDDR2] = "Registered-DDR2"
 };
 
 static const char *dev_types[] = {

