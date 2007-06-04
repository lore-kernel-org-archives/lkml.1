Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbXFDITT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbXFDITT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 04:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXFDITN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 04:19:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:45033 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbXFDITM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 04:19:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Zewvm1cae/HS5doUGNAScmGaQfa4iMk/6blXH7pJO04lnr/Mh02XrFmEkPZkC6ByakaeodoCE+G0VYc1TaoRh8MtRNwicBQ17TeuqdAk+k4vb58NzopedOiGRUYWKOEZRxZm69oVQnHh/IxsI9iLVfeGbRGDsjg1ZXAA3mmruxA=
Date: Mon, 4 Jun 2007 16:19:38 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Al Viro <viro@ftp.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, Chen Li-jun <cljun@xiyou.edu.cn>,
       Wang Ya-gang <lazy_linux@126.com>
Subject: [RFC] Documentation/CodingStyle: Add rules for goto labels (-v2)
Message-ID: <20070604081938.GC2074@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Jeremy Fitzhardinge <jeremy@goop.org>,
	Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
	Al Viro <viro@ftp.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
	Chen Li-jun <cljun@xiyou.edu.cn>, Wang Ya-gang <lazy_linux@126.com>
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <20070604045857.GE2161@localhost.localdomain> <4663B84E.2060103@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4663B84E.2060103@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Lindent gets wrong when it meets goto labels. This should be fixed manually.
And kernel's CodingStyle doesn't specify the indentation for goto labels explicitly.

This patch adds specifications on those things about goto labels in CodingStyle. And it is
against -rc3 source tree.

Thanks to Al Viro, Randy Dunlap, Jeff Garzik and Jeremy Fitzhardinge for their comments!

Regards!

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 CodingStyle |    7 +++++++
 1 file changed, 7 insertions(+)

--- linux-2.6.22-rc3/Documentation/CodingStyle.orig	2007-06-04 15:53:58.000000000 +0800
+++ linux-2.6.22-rc3/Documentation/CodingStyle	2007-06-04 16:04:31.000000000 +0800
@@ -66,6 +66,13 @@ something to hide:
 Don't put multiple assignments on a single line either.  Kernel coding style
 is super simple.  Avoid tricky expressions.
 
+Do care when you use Lindent to indent your code, since it may use spaces
+instead of tabs before a goto label and it may also align the label in a
+wrong position. Generally speaking, a goto label should be always aligned in
+the first column. However, it might make sense to indent a label deeper if
+you've actually declared it local (__label__). Please fix it manually if you
+find Lindent is wrong.
+
 Outside of comments, documentation and except in Kconfig, spaces are never
 used for indentation, and the above example is deliberately broken.
 

