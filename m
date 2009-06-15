Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbZFOMQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbZFOMQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758317AbZFOMQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:16:22 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:50291 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbZFOMQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:16:21 -0400
In-Reply-To: <200906140023.06690.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 07/27] score: create head files elf.h emergency-restart.h
 errno.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF48364F7F.ED6F93C7-ON482575D6.0042A7E0-482575D6.0043654D@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Mon, 15 Jun 2009 20:11:34 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/15 ?? 08:11:35,
	Serialize complete at 2009/06/15 ?? 08:11:35
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5FCH654011901

Arnd Bergmann <arnd@arndb.de> Ğ´ÓÚ 2009-06-14 06:23:06:

> On Saturday 13 June 2009, liqin.chen@sunplusct.com wrote:
> > > 
> > > EMAXERRNO is mips specific right now. Do you actually need it 
somewhere?
> > > 
> > 
> > Yes, I used it in entry.S, maybe I could remove this define latter.
> > 
> 
> Ok. Note that the maximum error number that is supposed to get sent back
> to user space is 511. Most architectures check the return value of the
> system call to be between -4095 and zero upon entering user space.
> Checking it in the kernel gives you the chance to override the
> error status from a system call with force_successful_syscall_return().
> 
> If that is your intention, you should probably leave the definition in 
there.
> Powerpc uses _LAST_ERRNO for the same purpose, which is somewhat 
inconsistent
> with mips and also uses a different value to compare against.
> 

Maybe I can don't use EMAXERRNO in score code. But I think define a 
maximum error number in asm-generic/errno.h is better.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
