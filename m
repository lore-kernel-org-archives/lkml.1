Return-Path: <linux-kernel-owner+w=401wt.eu-S1762368AbXFGO23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762368AbXFGO23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbXFGO2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:28:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:15534 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbXFGO2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:28:21 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jun 2007 10:28:21 EDT
Date: Thu, 7 Jun 2007 16:28:20 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
In-Reply-To: <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
 <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-131101332-1181226500=:8762"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-131101332-1181226500=:8762
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Jun 6 2007 11:05, Jesper Juhl wrote:
>
> - Source files should be 7bit ASCII

Nah. Think of....

MODULE_AUTHOR("J. Ørsted <jorsted@foobar.com>");

> - Maybe warn about usage of float/double in source files?

Generally yes, maybe, but see arch/i386/kernel/cpu/bugs.c,
arch/i386/math-emu/. Generally there is nothing to it. I think the
feature to allow the kernel to use [i387] FP without manually
saving/restoring the FP stack has been added some time ago.

> - 'return' is not a function, so warn about patches that think it is
> and use 'return(expr);' (this one is tricky since 'return (expr);' can
> be OK in some cases.

Now, if we could detect superfluous parentheses and branches,
that'd be cool ;-) there are too many if ((a < 5) || (b > 6)) around.




	Jan
-- 
---699020219-131101332-1181226500=:8762--
