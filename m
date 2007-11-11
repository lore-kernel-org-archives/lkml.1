Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbXKLABW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbXKLABW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 19:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbXKLABL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 19:01:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:61413 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720AbXKLABK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 19:01:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=T1R40ijGdKckd5ENcsWuHHGRr+ghrwT2By9ylitGXAX9ygFzRoZ6fHlqlpBW00xMPo/H+8/BKAZdbez/5h7d7yvH7ILvwkSlwAHWWklcTUGrrBIp5pxx5MK/VEWXWfMuJeg6Hqt2IPNHa+PxwK7+LqVa7XUIY9nrY9eRtC8v57c=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Let 'make help' output info about includecheck
Date: Mon, 12 Nov 2007 00:56:35 +0100
User-Agent: KMail/1.9.7
Cc: Sam Ravnborg <sam@ravnborg.org>, trivial@kernel.org,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711120056.35359.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>

'make includecheck' is useful and we want people to run it, so 
let 'make help' output information about its existence.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 Makefile |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index e28dde8..2e5eba0 100644
--- a/Makefile
+++ b/Makefile
@@ -1181,6 +1181,7 @@ help:
 	@echo  ''
 	@echo  'Static analysers'
 	@echo  '  checkstack      - Generate a list of stack hogs'
+	@echo  '  includecheck    - Generate a list of files with duplicate header includes'
 	@echo  '  namespacecheck  - Name space analysis on compiled kernel'
 	@echo  '  export_report   - List the usages of all exported symbols'
 	@if [ -r $(srctree)/include/asm-$(SRCARCH)/Kbuild ]; then \


