Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbZFIJcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbZFIJcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 05:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758871AbZFIJcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 05:32:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57656 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757815AbZFIJcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 05:32:46 -0400
Date: Tue, 9 Jun 2009 19:32:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the voyager tree with the rr tree
Message-Id: <20090609193246.d86bf703.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Today's linux-next merge of the voyager tree got a conflict in
drivers/lguest/Kconfig between commit
7f8f1b5390ac9c433b0c4c693201a36fa3234a41 ("lguest:eventfd-notify") from
the rr tree and commit 0ff51d1467af91bca4210b0d09372b6e7ded7524 ("Revert
"x86: remove the Voyager 32-bit subarch"") from the voyager tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/lguest/Kconfig
index 6c566c1,76f2b36..0000000
--- a/drivers/lguest/Kconfig
+++ b/drivers/lguest/Kconfig
@@@ -1,6 -1,6 +1,6 @@@
  config LGUEST
  	tristate "Linux hypervisor example code"
- 	depends on X86_32 && EXPERIMENTAL && !X86_PAE && EVENTFD
 -	depends on X86_32 && EXPERIMENTAL && !X86_PAE && FUTEX && !X86_VOYAGER
++	depends on X86_32 && EXPERIMENTAL && !X86_PAE && EVENTFD && !X86_VOYAGER
  	select HVC_DRIVER
  	---help---
  	  This is a very simple module which allows you to run
