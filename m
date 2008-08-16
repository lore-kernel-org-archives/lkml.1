Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYHPWit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYHPWit (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 18:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbYHPWiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 18:38:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193AbYHPWiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 18:38:23 -0400
Subject: patch uml-missing-export-of-csum_partial-on-uml-amd64.patch added to 2.6.25-stable tree
To: viro@ftp.linux.org.uk, gregkh@suse.de, jdike@addtoit.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Sat, 16 Aug 2008 15:32:44 -0700
In-Reply-To: <20080805201407.GA11790@c2.user-mode-linux.org>
Message-Id: <20080816223821.8D32C1454450@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

    Subject: uml: missing export of csum_partial() on uml/amd64

to the 2.6.25-stable tree.  Its filename is

    uml-missing-export-of-csum_partial-on-uml-amd64.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Tue Aug  5 13:14:50 2008
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 5 Aug 2008 16:14:07 -0400
Subject: uml: missing export of csum_partial() on uml/amd64
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Message-ID: <20080805201407.GA11790@c2.user-mode-linux.org>
Content-Disposition: inline

From: Al Viro <viro@ftp.linux.org.uk>

commit 3e3b48e5198544dd90e27265a70c1a834139e025 upstream

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/sys-x86_64/ksyms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/um/sys-x86_64/ksyms.c
+++ b/arch/um/sys-x86_64/ksyms.c
@@ -14,3 +14,4 @@ EXPORT_SYMBOL(__up_wakeup);
 
 /*XXX: we need them because they would be exported by x86_64 */
 EXPORT_SYMBOL(__memcpy);
+EXPORT_SYMBOL(csum_partial);


Patches currently in stable-queue which might be from viro@ftp.linux.org.uk are

queue-2.6.25/uml-missed-kmalloc-in-pcap_user.c.patch
queue-2.6.25/uml-missing-export-of-csum_partial-on-uml-amd64.patch
