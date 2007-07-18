Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbXGRJ02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbXGRJ02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbXGRJ0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:26:21 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:54841 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbXGRJ0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:26:20 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 18 Jul 2007 05:24:28 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][RFC] Delete export of tty.h to userspace.
Message-ID: <Pine.LNX.4.64.0707180520040.19434@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  given that the entire contents of include/linux/tty.h is contained
within an "#ifdef __KERNEL__", it seems pointless to export it to
userspace, unless there's some kind of need for that header file to
exist in userspace, even if it's empty.

  a quick grep shows that nothing under /usr/include references any
file of the name "tty.h" in any way.  thoughts?



 diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 4ff0f57..63de91a 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -328,7 +327,6 @@ unifdef-y += sysctl.h
 unifdef-y += tcp.h
 unifdef-y += time.h
 unifdef-y += timex.h
-unifdef-y += tty.h
 unifdef-y += types.h
 unifdef-y += udf_fs_i.h
 unifdef-y += udp.h
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
