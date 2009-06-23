Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbZFWK5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbZFWK5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbZFWK5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:57:05 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:49005 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbZFWK5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:57:04 -0400
In-Reply-To: <200906231143.22985.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Subject: Re: S+core architecture (arch/score/) support files
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFF803D403.C007681C-ON482575DE.003B06AD-482575DE.003C1D98@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 23 Jun 2009 18:51:47 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/23 ?? 06:51:48,
	Serialize complete at 2009/06/23 ?? 06:51:48
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5NAwB54013588

Arnd Bergmann <arnd@arndb.de> Ğ´ÓÚ 2009-06-23 17:43:22:

> On Tuesday 23 June 2009, liqin.chen@sunplusct.com wrote:
> > Hi Linus,
> > 
> > This repository contains Linux support for S+core CPU.
> > 
> > Please pull
> > git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git 
score
> 
> I've helped Liquin getting this into a state for inclusion,
> so I'll share my observations about the submission.
> 
> The code looks very clean for a new architecture support, with the
> exception of a few misformatted comments and similar minor issues.
> By using the asm-generic headers that are now in 2.6.31, the amount
> of copy-paste programming was reduced to a minimum, the total amount
> of code added is much less than any other architecture (200kb score,
> 290kb h8300, 570kb microblaze are the smallest ones).
> Fixes for any issues noted during review usually came in quickly.
> 
> S+core is now the first architecture to use the ABI defined in
> asm-generic, which means it can serve as an example for other
> architectures that want to merge their code in the future.
> 
> Unfortunately, I don't think that the score glibc has been fully
> ported to support this, so it also means that the version that is
> being submitted has undergone any run-time testing. I did check
> that it compiles fine but could not do more in lack of hardware
> or even just a user space distro.
> 
> Another small negative is that Liquin is still unexperienced with
> the procedures we use in Linux. I've helped out by providing
> my git tree, but am not planning to do that beyond 2.6.31.
> Given that he has also been upstream gcc maintainer for S+core
> for well over 2 years, I believe merging it now will work out well.
> 

Thanks Arnd.
With the help of Arnd, linux/score code become more and more clear.

Before we commit the code to linux.org, 
Linux had run on spct6600 score platform well. 
It had passed LTP test and could run many general applications.
S+core application depend on glibc-2.3.6, which support static
and dynamic applications.

We will upgrade glibc to catch up with the linux/score updating.

Best Regards
Liqin
---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
