Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYHQBeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYHQBeg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 21:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYHQBe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 21:34:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:5638 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbYHQBe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 21:34:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=oPg7ay4eh63a3FWpmblB3tsUN6qk9imKp7zepcELLQAftD+cZofNc7yy49MSG4bnli
         EfOk5jOrPG6BGiKVjcqZUoA3J97JI7RvmGR5fzNAPaHstyjEpgqkCZH+TM5SvWoVP+2l
         qvlZs2xGwG9PJ954sQ/Trvg6AMiwDrw9YgkCE=
Date: Sun, 17 Aug 2008 05:34:20 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: dhowells@redhat.com, serue@us.ibm.com, casey@schaufler-ca.com,
       morgan@kernel.org, viro@zeniv.linux.org.uk, jmorris@namei.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] security.h: fix build failure 
Message-ID: <20080817013420.GA7622@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

security.h: fix build failure

include/linux/security.h: In function 'security_ptrace_traceme':
include/linux/security.h:1760: error: 'parent' undeclared (first use in this function)


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 include/linux/security.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 2ee5ecf..80c4d00 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1755,7 +1755,7 @@ static inline int security_ptrace_may_access(struct task_struct *child,
 	return cap_ptrace_may_access(child, mode);
 }
 
-static inline int security_ptrace_traceme(struct task_struct *child)
+static inline int security_ptrace_traceme(struct task_struct *parent)
 {
 	return cap_ptrace_traceme(parent);
 }
