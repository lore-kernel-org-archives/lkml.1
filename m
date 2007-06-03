Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbXFCOY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbXFCOY0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXFCOYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:24:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:33675 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbXFCOYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=MHMKkcr4eQagaoiGVTqvbUpMDULqxZ/0cYASifyPaVB4pRt58Ht2jzW23jz9727EPyBBVDvxw+C2ieF/2CF++Cr80cyymwkdCfs4oDTsjxTfSgc5D47LFUMgILywOSVpE2Cmq0E2hCYwqzSWRAVQTMdY5hPXWlauStF/gy7hzwo=
Date: Sun, 3 Jun 2007 22:24:50 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: rdunlap@xenotime.net, akpm@linux-foundation.org,
       Chen Li-jun <cljun@xiyou.edu.cn>, Wang Ya-gang <lazy_linux@126.com>
Subject: [RFC] Documentation/CodingStyle: Add rules for goto labels
Message-ID: <20070603142450.GA4230@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net,
	akpm@linux-foundation.org, Chen Li-jun <cljun@xiyou.edu.cn>,
	Wang Ya-gang <lazy_linux@126.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There are many people use Lindent to indent their code, but Lindent gets wrong when it
meets goto labels. This should be fixed manually. 

And kernel's CodingStyle doesn't specify the indentation for goto labels explicitly.

This patch adds specifications on those things about goto labels in CodingStyle. And it is 
against -rc3 source tree.

Any advice or comments are more than welcome!

Regards!

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 CodingStyle |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-2.6.22-rc3/Documentation/CodingStyle.orig	2007-06-03 21:28:19.000000000 +0800
+++ linux-2.6.22-rc3/Documentation/CodingStyle	2007-06-03 21:51:21.000000000 +0800
@@ -66,6 +66,12 @@ something to hide:
 Don't put multiple assignments on a single line either.  Kernel coding style
 is super simple.  Avoid tricky expressions.
 
+Do care when you use Lindent to indent your code, since it may use spaces
+instead of tabs before a goto label and it may also align the label in a
+wrong position. A goto label should be aligned in the column that is 8
+characters ahead of the statement just below this label. Please fix it manually
+if you find Lindent is wrong.
+
 Outside of comments, documentation and except in Kconfig, spaces are never
 used for indentation, and the above example is deliberately broken.
 
