Return-Path: <linux-kernel-owner+w=401wt.eu-S1422710AbXBAJkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422710AbXBAJkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 04:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422728AbXBAJjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 04:39:42 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35784 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422710AbXBAJjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 04:39:09 -0500
Date: Thu, 1 Feb 2007 10:29:56 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-aio <linux-aio@kvack.org>,
       Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Badari Pulavarty <pbadari@us.ibm.com>,
       Benjamin LaHaise <bcrl@linux.intel.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: [PATCH -mm 2/7][AIO] - fix aio.h includes
Message-ID: <20070201102956.7c15ab27@frecb000686>
In-Reply-To: <20070201102252.240130c6@frecb000686>
References: <20070201102252.240130c6@frecb000686>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 01/02/2007 10:40:00,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 01/02/2007 10:40:07,
	Serialize complete at 01/02/2007 10:40:07
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sébastien Dugué <sebastien.dugue@bull.net>

  Fix the double inclusion of linux/uio.h in linux/aio.h



 aio.h |    1 -
 1 file changed, 1 deletion(-)

Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>

Index: linux-2.6.20-rc6-mm3/include/linux/aio.h
===================================================================
--- linux-2.6.20-rc6-mm3.orig/include/linux/aio.h	2007-01-30 10:05:08.000000000 +0100
+++ linux-2.6.20-rc6-mm3/include/linux/aio.h	2007-01-30 10:11:22.000000000 +0100
@@ -7,7 +7,6 @@
 #include <linux/uio.h>
 
 #include <asm/atomic.h>
-#include <linux/uio.h>
 
 #define AIO_MAXSEGS		4
 #define AIO_KIOGRP_NR_ATOMIC	8
