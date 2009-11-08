Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbZKHL6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbZKHL6J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbZKHL6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:58:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:52706 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbZKHL6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:58:07 -0500
Date: Sun, 8 Nov 2009 11:57:36 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sfr@canb.auug.org.au, tglx@linutronix.de, rientjes@google.com,
       randy.dunlap@oracle.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, sfr@canb.auug.org.au, randy.dunlap@oracle.com,
       rientjes@google.com, mingo@elte.hu
In-Reply-To: <20091028160955.d27ccb16.randy.dunlap@oracle.com>
References: <20091028160955.d27ccb16.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: k8.h: Add struct bootnode
Message-ID: <tip-0420101c075530c65ba00b6fe7291b126fbfc5d2@git.kernel.org>
Git-Commit-ID: 0420101c075530c65ba00b6fe7291b126fbfc5d2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0420101c075530c65ba00b6fe7291b126fbfc5d2
Gitweb:     http://git.kernel.org/tip/0420101c075530c65ba00b6fe7291b126fbfc5d2
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Wed, 28 Oct 2009 16:09:55 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 12:55:38 +0100

x86: k8.h: Add struct bootnode

k8.h uses struct bootnode but does not #include a header file
for it, so provide a simple declaration for it.

  arch/x86/include/asm/k8.h:13: warning: 'struct bootnode'
  declared inside parameter list arch/x86/include/asm/k8.h:13:
  warning: its scope is only this definition or declaration, which is probably not what you want

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
LKML-Reference: <20091028160955.d27ccb16.randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/k8.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index c092f72..f70e600 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -4,6 +4,7 @@
 #include <linux/pci.h>
 
 extern struct pci_device_id k8_nb_ids[];
+struct bootnode;
 
 extern int early_is_k8_nb(u32 value);
 extern struct pci_dev **k8_northbridges;
