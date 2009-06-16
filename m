Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbZFPDbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbZFPDbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 23:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZFPDbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 23:31:13 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:37920 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZFPDbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 23:31:12 -0400
In-Reply-To: <200906151602.42873.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-arch-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
       liqin.chen@sunplusct.com, Matthew Wilcox <matthew@wil.cx>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH] asm-generic: add EMAXERRNO
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFD9F2472F.5C67128A-ON482575D7.000F7E83-482575D7.0011466D@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 16 Jun 2009 11:04:10 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/16 ?? 11:04:11,
	Serialize complete at 2009/06/16 ?? 11:04:11
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5G3Vv54023124

linux-arch-owner@vger.kernel.org Ğ´ÓÚ 2009-06-15 22:02:42:

> On Monday 15 June 2009, Matthew Wilcox wrote:
> > On Mon, Jun 15, 2009 at 03:30:09PM +0200, Arnd Bergmann wrote:
> > > Some architectures want to flag error returns from a syscall based 
on
> > > the return value. The range from zero to -511 is for errors that
> > > we can return to user space, so add a #define for this to
> > > include/asm-generic/errno.h.
> > 
> > I thought we could return anything up to -4095.
> 
> Sort of, yes. Internally to the kernel, we use anything up to 4095,
> that's e.g. IS_ERR_VALUE checks for.
> 
> Error numbers from 512 to 4095 are internal and should never be seen
> by the user.
> 
> In reality, it probably does not matter at all because we know what
> error numbers we use. Now that you pointed me to include/linux/err.h,
> that already defines MAX_ERRNO.
> 
> Liqin, I think I'd prefer to just drop my patch again, and you can
> use MAX_ERRNO, which is defined in err.h.
> 
OK.
But I think move MAX_ERRNO define from include/linux/err.h to 
include/asm-generic/errno.h will be more clear. And no harm to
include/linux/err.h file.

liqin
--
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
