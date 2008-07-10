Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYGJMF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYGJMF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 08:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYGJMFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 08:05:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:58751 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbYGJMFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 08:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=jiaHnoj3mG9aR9NvGSUnBCPYjc1lARPN5L9phtwzfNWE2QSTv+h8IOUMQGlqnGt8yl
         LWjcNbbmn8lcDJDlyiuWa0jOcwSIml09bfaUUPg7uByHSIJ5rQ+z+DtsCXq9szri/bBj
         yQ95JtOO4WMkBwduaDN5EHCxPnAh+8jQKTsxA=
Date: Thu, 10 Jul 2008 16:02:27 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: [PATCH] PREEMPT_RCU: remove unused rcu_tasklet
Message-ID: <20080710120227.GA32491@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/rcupreempt.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -82,7 +82,6 @@ struct rcu_data {
 	spinlock_t	lock;		/* Protect rcu_data fields. */
 	long		completed;	/* Number of last completed batch. */
 	int		waitlistcount;
-	struct tasklet_struct rcu_tasklet;
 	struct rcu_head *nextlist;
 	struct rcu_head **nexttail;
 	struct rcu_head *waitlist[GP_STAGES];

