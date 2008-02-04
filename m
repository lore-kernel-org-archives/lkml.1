Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbYBDRLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbYBDRLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYBDRLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:11:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:63437 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbYBDRLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:11:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=WO11ehuEMbzPiHYVaM3WhdxwUx2g415EhjfzFDq3J538b4K/vu/rBrXUMO3E8YCut8hz4bE7WCQlAHybzrS2JU4FaBLvxiAs5DU/EBQm8xpzU4NrRRPyXddvZE++E9FGcXWwq21Lcc6eMU1zkB/qPEs2RzuU2TiDk4cJNy5aNXI=
Date: Mon, 4 Feb 2008 20:10:37 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: vmlinux_64.lds.S - use THREAD_SIZE instead of numeric
	constant
Message-ID: <20080204171037.GA6743@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/vmlinux_64.lds.S	2008-01-30 17:51:57.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/vmlinux_64.lds.S	2008-02-03 22:38:48.000000000 +0300
@@ -129,7 +129,7 @@ SECTIONS
 #undef VVIRT_OFFSET
 #undef VVIRT
 
-  . = ALIGN(8192);		/* init_task */
+  . = ALIGN(THREAD_SIZE);	/* init_task */
   .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
 	*(.data.init_task)
   }:data.init
