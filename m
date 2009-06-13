Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbZFMGzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbZFMGzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 02:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZFMGzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 02:55:47 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:33273 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZFMGzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 02:55:46 -0400
In-Reply-To: <200906092019.06812.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 00/27] score arch files for linux
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFFDE0B66A.CCDF7360-ON482575D4.0024FAC6-482575D4.00260499@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Sat, 13 Jun 2009 14:50:47 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/13 ?? 02:50:48,
	Serialize complete at 2009/06/13 ?? 02:50:48
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5D6uU54011807

Hi Arnd,

Arnd Bergmann <arnd@arndb.de> Ğ´ÓÚ 2009-06-10 02:19:06:

> On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:
> > Hi Arnd, Andrew Morton and linus,
> > 
> > According to your comment on score arch code, 
> > we update score code base on asm-generic#next repository.
> > use arch microblaze and blackfin as reference.
> 
> Ok, just finished looking over the patches and I am generally
> very happy about their quality, it usually takes much longer
> for a submission of this size to get into a mergeable shape.
> 
> The only thing that I think needs to be fixed before a
> 2.6.31 release is my comment about unistd.h still containing
> the __ARCH_WANT_SYSCALL_* #defines. I consider that my fault
> because I did not make it clear enough what those are meant
> for in asm-generic/unistd.h.
> 
> One more general thought: I noticed that you split the header
> files by alphabetical ordering. While there is no good way to
> split a set of interdependent files, a logical grouping
> (e.g. ABI, memory management, device, cpu) would be nice.
> 
> Everything else I found are only polite suggestions of what
> can still be improved, not issues that I think need to
> be addressed immediately. I especially love how the work
> that Remis and I put into the generic header files starts
> paying off, because it makes reviewing an architecture so
> much simpler.
> 
> Please add my 'Reviewed-by: Arnd Bergmann <arnd@arndb.de>'
> to your patches.
> 

Based on your comments, I use asm-generic/current.h, hardirq.h,
unaligned.h etc instead of files under arch/include/asm folder.
It could work in score code.

Best Regards
Liqin
--


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
