Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbXFCOvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbXFCOvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbXFCOor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:44:47 -0400
Received: from web50101.mail.re2.yahoo.com ([206.190.38.29]:41601 "HELO
	web50101.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754666AbXFCOop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:44:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=d1Rz5UeGY5/GfREYwXIkmSxzkOWHH97ybSEAuf719W5IAREzbUfhTA/HOLmoZStkngxJ62rL7BSxOj2kj0nAFGLzD9z4H8642XfRd8bOzpgidV9jic1zRl5YPLjGo8e1Mzd9Da66oP+xRT8pCtAvTNhDs7IgJgHoXAHY8b2ZUSk=;
X-YMail-OSG: lr4yLKwVM1nckJYdR3419llyiikbdP3Jpksgzhpr9vZZPcIiWR3N5hjM3MxbPojBydLETU_83.a6c0_B3iCG.0dUQ9wc6l8GsjxDCKKflif9JZcL.XVgl9xyCEYZ_ggvhweo1sBnXH8-
Date: Sun, 3 Jun 2007 07:44:43 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 35/36] drivers edac clarified help for edac
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <194458.22773.qm@web50101.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

Clarified the help of EDAC

Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>

---
 Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc3-mm1/drivers/edac/Kconfig
===================================================================
--- linux-2.6.22-rc3-mm1.orig/drivers/edac/Kconfig
+++ linux-2.6.22-rc3-mm1/drivers/edac/Kconfig
@@ -13,8 +13,9 @@ menuconfig EDAC
 	help
 	  EDAC is designed to report errors in the core system.
 	  These are low-level errors that are reported in the CPU or
-	  supporting chipset: memory errors, cache errors, PCI errors,
-	  thermal throttling, etc..  If unsure, select 'Y'.
+	  supporting chipset or other subsystems:
+	  memory errors, cache errors, PCI errors, thermal throttling, etc..
+	  If unsure, select 'Y'.
 
 	  If this code is reporting problems on your system, please
 	  see the EDAC project web pages for more information at:

