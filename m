Return-Path: <linux-kernel-owner+w=401wt.eu-S932838AbXBFQIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbXBFQIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932999AbXBFQIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:08:22 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:59552 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838AbXBFQIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:08:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=evYSxboav3TpzYr94MPxd/Rf+VfVMQSs+/pYGzD1Yo/DmccR4CD5j0rRn5bl32R6Xc+kowWZMqoW/doHACfWKHZQWjtR8VbBGAspgJbu3pOcd9g33b0rzEnylMCLgV/mj04DcGlCtla0HcLzOci7uYw/pXzFVxe194bHU06p4dc=
Date: Tue, 6 Feb 2007 18:08:06 +0200
To: josh@freedesktop.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] rcutorture: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206160806.GL8991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206160204.GA8991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 482b11f..97c2277 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -899,7 +899,7 @@ rcu_torture_init(void)
 	/* Set up the freelist. */
 
 	INIT_LIST_HEAD(&rcu_torture_freelist);
-	for (i = 0; i < sizeof(rcu_tortures) / sizeof(rcu_tortures[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(rcu_tortures); i++) {
 		rcu_tortures[i].rtort_mbtest = 0;
 		list_add_tail(&rcu_tortures[i].rtort_free,
 			      &rcu_torture_freelist);


-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
