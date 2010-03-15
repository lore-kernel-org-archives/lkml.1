Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862Ab0COIWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 04:22:05 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:60015 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759838Ab0COIWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 04:22:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=W6QqK/1pYwRG5LkuFl+KaQ5/HDnufn6J2APfi3dzoPjJoKXWh4WvMhJF2gFNpzo2rE
         WPK3SEO9YJb8R3sbQV9HuVeqpPPccXniE7vvhDhljXEFOjhlIRs5QF1m7Hz6PhDe8AOF
         Z4bjI0G62IeBncBF5WnKPNck3OrVoY2E8ae4o=
Date: Mon, 15 Mar 2010 11:21:48 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] sched: remove some dead code
Message-ID: <20100315082148.GD18181@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Kay Sievers <kay.sievers@vrfy.org>, Ingo Molnar <mingo@elte.hu>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was left over from "7c9414385e sched: Remove USER_SCHED"

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/kernel/user.c b/kernel/user.c
index 766467b..ec3b222 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -178,8 +178,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 
 	return up;
 
-	put_user_ns(new->user_ns);
-	kmem_cache_free(uid_cachep, new);
 out_unlock:
 	return NULL;
 }
