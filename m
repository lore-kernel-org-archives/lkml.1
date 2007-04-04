Return-Path: <linux-kernel-owner+w=401wt.eu-S2992859AbXDDL1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992859AbXDDL1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 07:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992861AbXDDL1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 07:27:23 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:56435 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992859AbXDDL1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 07:27:22 -0400
Message-ID: <46138B4C.2050409@gmail.com>
Date: Wed, 04 Apr 2007 13:26:04 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: MODULE_MAINTAINER
Content-Type: multipart/mixed;
 boundary="------------070305020103070403050608"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070305020103070403050608
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Rusty.

Can we have a MODULE_MAINTAINER to complement MODULE_AUTHOR?

Often a module grows multiple authors over time, but initial authors 
aren't around (or too interested) anymore. And sometimes, if someone 
maintaining a driver is just doing minor peripheral updates to keep it 
compiling, the maintainer might not even _be_ an author really...

Rene.



--------------070305020103070403050608
Content-Type: text/plain;
 name="module_maintainer.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="module_maintainer.diff"

diff --git a/include/linux/module.h b/include/linux/module.h
index 10f771a..c06f76c 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -128,6 +128,9 @@ #define MODULE_LICENSE(_license) MODULE_
 /* Author, ideally of form NAME <EMAIL>[, NAME <EMAIL>]*[ and NAME <EMAIL>] */
 #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)
   
+/* Maintainer, ideally of form NAME <EMAIL> */
+#define MODULE_MAINTAINER(_maintainer) MODULE_INFO(maintainer, _maintainer)
+
 /* What your module does. */
 #define MODULE_DESCRIPTION(_description) MODULE_INFO(description, _description)
 

--------------070305020103070403050608--
