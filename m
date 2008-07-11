Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbYGKOyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbYGKOyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYGKOyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:54:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:41743 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbYGKOyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=C1qCgyjCVqwd0woqMORWAgkZDulxooldgudRN5W9+iFXazpO+w2LVAiDs4vQAI2cU8
         W1UkXWXPXLhd8j2Z+5ILi2QNvHqyzYExumYXjbsUtH5GgU3smT88RR7L3KWxeW4X6n3k
         hjKQW0o63UPlA38sQg/6ssKUT3nXbmjfYRVeY=
Message-ID: <19f34abd0807110754n1a095671ua9132471b6a81540@mail.gmail.com>
Date: Fri, 11 Jul 2008 16:54:04 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "=?UTF-8?Q?T=C3=B6r=C3=B6k_Edwin?=" <edwintorok@gmail.com>
Subject: Re: today's linux-next fails to boot
Cc: "Ingo Molnar" <mingo@elte.hu>, "Takashi Iwai" <tiwai@suse.de>,
       linux-next@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <487772B6.4090100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <4877400B.1000400@gmail.com> <s5hy747rvpr.wl%tiwai@suse.de>
	 <48775C69.6050107@gmail.com> <20080711135937.GA25004@elte.hu>
	 <487772B6.4090100@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6BEsOfq025819

On Fri, Jul 11, 2008 at 4:48 PM, TÃ¶rÃ¶k Edwin <edwintorok@gmail.com> wrote:>> One really simple way of getting some more info out of this is to take>> the EIP value (here c0181ca0) and run it through addr2line:>>>>     $ addr2line -e vmlinux -i c0181ca0>> Thanks for the hint, I rebuilt a failing kernel, and this is what> addr2line says:>> $ addr2line -e vmlinux -i c0181ca0>> ??:0> $ addr2line -e vmlinux -f c0181ca0> kmem_cache_alloc> ??:0
Ouch, sorry. You need CONFIG_DEBUG_INFO for this to really make anysense. My habits are deceiving me, because I always build withDEBUG_INFO. Ingo claims that this slows down his builds, so he neverdoes it. In the end, it is up to each one of us to choose his options,but in general, I think it should be used when testing kernels.
If you're tired of rebuilding kernels now, I don't blame you. Anotherlesson learned for me :-(

Vegard
-- "The animistic metaphor of the bug that maliciously sneaked in whilethe programmer was not looking is intellectually dishonest as itdisguises that the error is the programmer's own creation."	-- E. W. Dijkstra, EWD1036ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
