Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbYHRGhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbYHRGhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 02:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYHRGhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 02:37:07 -0400
Received: from zaphod.dth.net ([85.159.112.68]:40239 "EHLO zaphod.dth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYHRGhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 02:37:06 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2008 02:37:06 EDT
Date: Mon, 18 Aug 2008 08:29:44 +0200
From: dth <dth@dth.net>
To: linux-kernel@vger.kernel.org
Subject: [trivial] typo fixes 2.6.27-rc3-git4
Message-ID: <20080818062944.GA23961@dth.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During bootup i noticed a small typo passing by,
i used grep to search for it and found some more occurances.
Here's just cosmetic typo changes:


diff -ur linux-2.6.27-rc3-git4.orig/Documentation/cris/README linux-2.6.27-rc3-git4/Documentation/cris/README
--- linux-2.6.27-rc3-git4.orig/Documentation/cris/README	2008-07-13 23:51:29.000000000 +0200
+++ linux-2.6.27-rc3-git4/Documentation/cris/README	2008-08-18 08:13:03.007658248 +0200
@@ -27,7 +27,7 @@
 The ETRAX 100LX chip
 --------------------
 
-For reference, plase see the press-release:
+For reference, please see the press-release:
 
 http://www.axis.com/news/us/001101_etrax.htm
 
diff -ur linux-2.6.27-rc3-git4.orig/Documentation/ia64/kvm.txt linux-2.6.27-rc3-git4/Documentation/ia64/kvm.txt
--- linux-2.6.27-rc3-git4.orig/Documentation/ia64/kvm.txt	2008-08-18 08:09:37.467658000 +0200
+++ linux-2.6.27-rc3-git4/Documentation/ia64/kvm.txt	2008-08-18 08:15:45.057658558 +0200
@@ -1,5 +1,5 @@
 Currently, kvm module in EXPERIMENTAL stage on IA64. This means that
-interfaces are not stable enough to use. So, plase had better don't run
+interfaces are not stable enough to use. So, please had better don't run
 critical applications in virtual machine. We will try our best to make it
 strong in future versions!
 				Guide: How to boot up guests on kvm/ia64
diff -ur linux-2.6.27-rc3-git4.orig/net/netfilter/nf_conntrack_acct.c linux-2.6.27-rc3-git4/net/netfilter/nf_conntrack_acct.c
--- linux-2.6.27-rc3-git4.orig/net/netfilter/nf_conntrack_acct.c	2008-08-18 08:10:15.857658000 +0200
+++ linux-2.6.27-rc3-git4/net/netfilter/nf_conntrack_acct.c	2008-08-18 08:17:13.227658343 +0200
@@ -69,7 +69,7 @@
 	int ret;
 
 #ifdef CONFIG_NF_CT_ACCT
-	printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use\n");
+	printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use\n");
 	printk(KERN_WARNING "nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or\n");
 	printk(KERN_WARNING "sysctl net.netfilter.nf_conntrack_acct=1 to enable it.\n");
 #endif


-----------------------

I think the ia64/kvm.txt could be changed just a little to make it more readable.
Something along this would be (imho) very close to the original:

---------
Currently, kvm module is in EXPERIMENTAL stage on IA64. This means that
interfaces are not stable enough to be used. So, please don't run critical 
applications in virtual machine. We will try our best to make it
better in future versions
---------

But that's just personal taste, and i think everyone get's the point in the 
original text.

Danny

-- 
