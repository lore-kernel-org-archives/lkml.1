Return-Path: <linux-kernel-owner+w=401wt.eu-S940519AbXGUPNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940519AbXGUPNO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939474AbXGUPE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:39272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939205AbXGUPEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=KdkSyGRalBt4Yq0tt3Jy5V/kohn2C3uR5DUxI+Mb3GGZfVmbOAtQpWGkCqLPF2XGXYBkUYs04xq/wlvlffeZidKAxLGBzwfEAOVzbO5mcVHEp1lJBCygYiVYOoQeDF0Vl0LXhkV5zQMpQdoTNqINoO70qcI68k7RQfr1iQMPSiM=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][22/37] Clean up duplicate includes in include/linux/memory_hotplug.h
Date: Sat, 21 Jul 2007 17:03:27 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Andi Kleen <ak@suse.de>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.27367.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	include/linux/memory_hotplug.h


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 7b54666..b573d1e 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -3,7 +3,6 @@
 
 #include <linux/mmzone.h>
 #include <linux/spinlock.h>
-#include <linux/mmzone.h>
 #include <linux/notifier.h>
 
 struct page;
