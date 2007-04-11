Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXDKICS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXDKICS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbXDKICS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:02:18 -0400
Received: from smtp112.plus.mail.re2.yahoo.com ([206.190.53.37]:42651 "HELO
	smtp112.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750719AbXDKICR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:02:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=kdbheiE1jveabI9iUYhzT+FCfDCDUVv7vdz4eVaVY2Qp52yZ005IV1+xvFh1E8T9rFkOUDKF8pqM6Ioi2RkuuJ7hWQ9BdbvD8R38/nLVppvnCQqqYIWIjfMBok3ilEckoH1WArrJxd9SoeKwoa3hbzNTcSd8kNSbCZAasujIATY=  ;
X-YMail-OSG: oAVXgcwVM1lyLAe2.zLLHiXfsbWGnohFo.cBT9ltMA1xI0Fu3pAnRkIg9qM12w0dDW0.DwyYkPF.J_mY.oMCBDCchhyP4z8jmhoj8XpX2ad54iHIfEj1ZvjY.Zyk.8N70qrgtHnIzKhNuGc-
Date: Wed, 11 Apr 2007 10:02:12 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] [KERNEL-DOC] alphabetically-sorted entries in index.html of 'htmldocs'
Message-ID: <20070411080211.GB3982@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070410234422.GA30554@zmei.tnic> <20070410212143.3a5d786d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070410212143.3a5d786d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sorts the DOCBOOKS entries in Documentation/DocBook/Makefile
alphabetically.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>


Index: 21-rc6/Documentation/DocBook/Makefile
===================================================================
--- 21-rc6.orig/Documentation/DocBook/Makefile
+++ 21-rc6/Documentation/DocBook/Makefile
@@ -4,14 +4,13 @@
 # See Documentation/kernel-doc-nano-HOWTO.txt for instruction in how
 # to document the SRC - and how to read it.
 # To add a new book the only step required is to add the book to the
-# list of DOCBOOKS.
+# alphabetically-sorted (^^hint) list of DOCBOOKS
 
-DOCBOOKS := wanbook.xml z8530book.xml mcabook.xml videobook.xml \
-	    kernel-hacking.xml kernel-locking.xml deviceiobook.xml \
-	    procfs-guide.xml writing_usb_driver.xml \
-	    kernel-api.xml filesystems.xml lsm.xml usb.xml \
-	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
-	    genericirq.xml
+DOCBOOKS := deviceiobook.xml filesystems.xml gadget.xml genericirq.xml \
+	    kernel-api.xml kernel-hacking.xml kernel-locking.xml libata.xml \
+	    librs.xml lsm.xml mcabook.xml mtdnand.xml procfs-guide.xml \
+	    rapidio.xml usb.xml videobook.xml wanbook.xml \
+	    writing_usb_driver.xml z8530book.xml
 
 ###
 # The build process is as follows (targets):

-- 
Regards/Gruﬂ,
    Boris.
