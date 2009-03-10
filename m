Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZCJOhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZCJOhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbZCJOh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:37:28 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:42235 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbZCJOhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:37:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=G6Nl5b6+3XhXN4gef085BEyPu12QxjI5TvvtnLC1/FDEU744nnlIKAL88vySARkfZz
         LdXAABaicTDxvzG9fALdcadbqu/kEMJ6p7QoT3vfJD5zyDwLN9Q5vdVxLiV52QiosOMq
         p4jWgpNUV89zZLNfmwnhD+EabrVd/L7qVvLi8=
Date: Tue, 10 Mar 2009 23:37:02 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/2 -mmotm] debug-pagealloc: depend on CONFIG_DEBUG_KERNEL
Message-ID: <20090310143701.GA3151@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic debug-pagealloc should depend on CONFIG_DEBUG_KERNEL
as well as the architecture specific one.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-arch@vger.kernel.org
---
 mm/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6-mmotm/mm/Kconfig.debug
===================================================================
--- 2.6-mmotm.orig/mm/Kconfig.debug
+++ 2.6-mmotm/mm/Kconfig.debug
@@ -3,7 +3,7 @@ config WANT_PAGE_DEBUG_FLAGS
 
 config PAGE_POISONING
 	bool "Debug page memory allocations"
-	depends on !ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	depends on DEBUG_KERNEL && !ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select DEBUG_PAGEALLOC
 	select WANT_PAGE_DEBUG_FLAGS
 	help
