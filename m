Return-Path: <linux-kernel-owner+w=401wt.eu-S1763664AbYD0ULP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763664AbYD0ULP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbYD0ULA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:11:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:37965 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760944AbYD0UK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:10:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=asAyIjCmrewwM3LqmAxm1bU9ex1XP0DdaoIlDJaEnVjcr1ANyjhTb8nISOB/5gq3B6mXltdRqAQuggtt3xjbJjwY0mdZCAjLOzbFZ05yclnMiCpdRxwOopWsHYyZmLZyYOrsvdeI/pew6c7sJoGr9VZA2xSdyC+g+L6OzyGOvhM=
Date: Sun, 27 Apr 2008 22:11:03 +0200 (CEST)
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       trivial@kernel.org
Subject: [PATCH][Resend] Let SYSVIPC default to 'y'
Message-ID: <alpine.LNX.1.00.0804272208250.2352@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

[This patch was previously submitted on  24 April 2008 01:01]

Andrew; Will you take this in -mm or should I just queue it in Trivial (or 
drop it entirely)?


SYSVIPC is a pretty crucial feature that I doubt very much if anyone 
except embedded people should even consider disabling - it simply 
breaks too much software for a Linux box to really be useful without it, 
for most purposes.
For that reason I find it quite odd that the feature defaults to 'No' 
currently.  I really cannot see any reason why we wouldn't want this to 
default to 'Yes', so this patch changes the default by adding 'default y' 
to Kconfig.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index ba3a389..023b2b6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -112,6 +112,7 @@ config SWAP
 
 config SYSVIPC
 	bool "System V IPC"
+	default y
 	---help---
 	  Inter Process Communication is a suite of library functions and
 	  system calls which let processes (running programs) synchronize and



