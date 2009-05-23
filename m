Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZEWKNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZEWKNP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 06:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZEWKNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 06:13:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:29487 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZEWKNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 06:13:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=cLLYyHnpx2tumZ6d7LvRbYogYRQHCW2d/ABTN+Huox88qzXL4Vs+ekS80x/GgCThUq
         vNMxdWdhg5U9yTAUMAVg4CLxkRmT9qk6Zrfr2GTo+K5OkatEzedia+ioU9zRwlT3IBYy
         +fn0QXLx3HI5ktQuXtJ2uwfkMfBdBBHVcMMuM=
Date: Sat, 23 May 2009 18:10:49 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com
Subject: [PATCH] forget a blankspace before 'name'
Message-ID: <20090523101049.GA7209@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


here should add some space before "name="

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 kernel/auditsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 7d6ac7c..aa0428e 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1478,7 +1478,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 			case 0:
 				/* name was specified as a relative path and the
 				 * directory component is the cwd */
-				audit_log_d_path(ab, "name=", &context->pwd);
+				audit_log_d_path(ab, " name=", &context->pwd);
 				break;
 			default:
 				/* log the name's directory component */
-- 
1.5.6.5

-- 
--------------------------------
http://zhwen.org - Open and Free
