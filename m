Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbZFMGor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbZFMGor (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 02:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbZFMGol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 02:44:41 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:58978 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbZFMGok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 02:44:40 -0400
In-Reply-To: <200906091920.09781.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 07/27] score: create head files elf.h emergency-restart.h
 errno.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF33B57F6A.69479DBB-ON482575D4.00247552-482575D4.002503BB@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Sat, 13 Jun 2009 14:39:50 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/13 ?? 02:39:51,
	Serialize complete at 2009/06/13 ?? 02:39:51
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5D6jN54011746

Arnd Bergmann <arnd@arndb.de> Ğ´ÓÚ 2009-06-10 01:20:09:

> On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:
> > --- /dev/null
> > +++ b/arch/score/include/asm/errno.h
> > @@ -0,0 +1,7 @@
> > +#ifndef _ASM_SCORE_ERRNO_H
> > +#define _ASM_SCORE_ERRNO_H
> > +
> > +#include <asm-generic/errno.h>
> > +#define EMAXERRNO 1024
> > +
> > +#endif /* _ASM_SCORE_ERRNO_H */
> 
> EMAXERRNO is mips specific right now. Do you actually need it somewhere?
> 

Yes, I used it in entry.S, maybe I could remove this define latter.

Best Regards
Liqin
--
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
