Return-Path: <linux-kernel-owner+w=401wt.eu-S1760475AbZEIDgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475AbZEIDgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZEIDfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:35:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:64595 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZEIDfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:35:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BlaK7Y4xJJVjMBFIh/NLhdsf70Y00oN2CglPGYGFCU7IdhNBnrbKsRxzmx14YzbLLm
         iQzWfYADhNPw8CGAAQ3Tm7xjxXBV/fyH4fgAv/3qs2fnbgXF5ghnBVgG4i3CZrwQ03tv
         eTZXf9UgCnLd3om65u6rd+TLRAJOl1+3dxYYU=
Date: Sat, 9 May 2009 07:36:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cred: #include init.h in cred.h
Message-ID: <20090509033652.GB3224@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/cred.h can't be included as first header (alphabetical order)
because it uses __init which is enough to break compilation on some
archs.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/cred.h |    1 +
 1 file changed, 1 insertion(+)

commit f3e00c7d1ece60a019b15ea4992821834fe21a31
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Fri May 8 20:46:18 2009 +0400

    cred.h: init.h

--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -13,6 +13,7 @@
 #define _LINUX_CRED_H
 
 #include <linux/capability.h>
+#include <linux/init.h>
 #include <linux/key.h>
 #include <asm/atomic.h>
 
