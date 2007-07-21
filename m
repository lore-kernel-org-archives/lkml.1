Return-Path: <linux-kernel-owner+w=401wt.eu-S941176AbXGUPQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941176AbXGUPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939174AbXGUPEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:36253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939505AbXGUPEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=FwAH163WzFayNV7ozAAxJGagGfNMajqnxzMHTGE8zTjvBc47gpgO6wNddd2gnR4EvY4fDFWbaqG+EmI4cnEKfSOclTM6KZbyRBs5rvINcNAnrn+4DMbHw/DEhyO77lw78qo85IoUMqdjUlwWsUsRiD3PMM+oJtgtfJZmI0GvDWQ=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][31/37] Clean up duplicate includes in net/sched/
Date: Sat, 21 Jul 2007 17:03:49 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Jamal Hadi Salim <hadi@cyberus.ca>,
       David S Miller <davem@davemloft.net>, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.49812.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	net/sched/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index bf90e60..6085be5 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -16,7 +16,6 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/skbuff.h>
-#include <linux/module.h>
 #include <linux/rtnetlink.h>
 #include <linux/init.h>
 #include <net/act_api.h>
