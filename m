Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZERXbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZERXbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 19:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZERXbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 19:31:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:34366 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZERXbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 19:31:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=iyrALib62UwA1lSJswBhHMYghoypK70H3QiSxSaucmREhzS+P1ikujEFgcLqr08PTn
         q4VKuYkh+wNRHfD1smoWoOTPQCEcPaaSdBSEFzfldRApqWK66WxSAWLn51a1shKAjH+t
         Lj4o//b8nyZAcVTS4qndjw9JdBag8+FQm804o=
Date: Mon, 18 May 2009 16:31:21 -0700
From: Chris Sanford <crsanford@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org
Subject: [PATCH] include KERN_* constant in printk calls
Message-ID: <20090518233121.GC3109@chrisubuntu-laptop>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, mingo@elte.hu,
	peterz@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the KERN_CONT constant to two printk calls.

Signed-off-by: Chris Sanford <crsanford@gmail.com>

---


diff --git a/kernel/sched.c b/kernel/sched.c
index 26efa47..6a2ed16 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7319,7 +7319,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
 
 	if (!(sd->flags & SD_LOAD_BALANCE)) {
-		printk("does not load-balance\n");
+		printk(KERN_CONT "does not load-balance\n");
 		if (sd->parent)
 			printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain"
 					" has parent");
@@ -7340,7 +7340,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 	printk(KERN_DEBUG "%*s groups:", level + 1, "");
 	do {
 		if (!group) {
-			printk("\n");
+			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: group is NULL\n");
 			break;
 		}
