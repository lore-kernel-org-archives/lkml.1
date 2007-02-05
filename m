Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbXBERBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbXBERBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932522AbXBERBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:01:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:29054 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbXBERBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:01:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=h5BN90n7o21hpgp7Dr8mIPxf53zwOa6u9VBtahhppGxL5dEjgSg5HeBY0X1sUAZe8Kp57JDjFfZ7scWJk5KmAw8N5nyUINMBorBSyES+ktzyxvVSRM0+fByAyqsMOGtE5TzgxYuxlPyzG2uVr3BlmqBRSDOuhVaudxRgU/djOvA=
Date: Mon, 5 Feb 2007 19:00:44 +0200
To: jt@hpl.hp.com, linville@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2.6.20] wavelan: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070205170044.GM3896@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205165429.GD3896@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A trivial patch to use ARRAY_SIZE macro.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/drivers/net/wireless/wavelan.p.h b/drivers/net/wireless/wavelan.p.h
index 72b646c..fe12c77 100644
--- a/drivers/net/wireless/wavelan.p.h
+++ b/drivers/net/wireless/wavelan.p.h
@@ -450,7 +450,7 @@ static const char	*version	= "wavelan.c : v24 (SMP + wireless extensions) 11/12/
 #define	WATCHDOG_JIFFIES	(512*HZ/100)
 
 /* Macro to get the number of elements in an array */
-#define	NELS(a)				(sizeof(a) / sizeof(a[0]))
+#define	NELS(a)				ARRAY_SIZE(a)
 
 /* ------------------------ PRIVATE IOCTL ------------------------ */
 



-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
