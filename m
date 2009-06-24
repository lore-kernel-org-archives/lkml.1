Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbZFXD24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbZFXD24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 23:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZFXD2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 23:28:48 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:38215 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZFXD2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 23:28:47 -0400
In-Reply-To: <87zlbz17fb.fsf@basil.nowhere.org>
To: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Subject: Re: S+core architecture (arch/score/) support files
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF06F6A918.AA4716A4-ON482575DF.000B4993-482575DF.0013010F@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 24 Jun 2009 11:22:44 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/24 ?? 11:22:46,
	Serialize complete at 2009/06/24 ?? 11:22:46
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5O3TY54026110

Andi Kleen <andi@firstfloor.org> Ğ´ÓÚ 2009-06-23 20:06:00:

> IMHO a full successfull LTP run should be minimal criterium for
> merging an architecture. That should catch most of the possible
> "simple" mistakes in the syscall ABI. I would suggest to wait to after
> this has been done.

Oh, Andi, it isn't a short time work. especially we use 
asm-generic/unistd.h instead of score old asm/unistd.h.
You see, the most work was focus on glibc/applications.

linux-arch-owner@vger.kernel.org Ğ´ÓÚ 2009-06-23 18:51:47:

> Before we commit the code to linux.org, 
> Linux had run on spct6600 score platform well. 
> It had passed LTP test and could run many general applications.
> S+core application depend on glibc-2.3.6, which support static
> and dynamic applications.

void merge_score_to_upstream(void)
{
        if (asm-generic is the right direction for all linux arch) {
                if (merge score code) {
                        It's easy for us to update score code and
                                commit the asm-generic problems we meet.
                } else {
                        People will pay no attation to score/asm-generic
                                problems.
                        printk("it haven't help asm-generic to stable.");
                }
        else {
                we could use score old asm/unistd.h instead.
        }
}

I think merge score to upstream will be no harm to linux kernel.

Christoph Hellwig <hch@infradead.org> Ğ´ÓÚ 2009-06-23 22:50:59:

> Still doesn't seem to be quite uptodate in the ptrace area, e.g. not
> using regsets at all.  It would be really helpful if the final ptrace
> code could be ran past Roland McGrath as the ptrace maintainer.

As a new comer, we don't know what we should or shouldn't do,
Since we begin to commit linux/score code to linux.org, we found
the best way is as simple as possible, because in linux world
people also have the different suggestions, it will make us 
confused and don't know what todo next soon.

The simple code has little error. We think it isn't the right
time to add utrace code so we don't do it.

Best Regards
Liqin
---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
