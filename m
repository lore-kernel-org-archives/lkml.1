Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbYL0IzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbYL0IzB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 03:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYL0Iyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 03:54:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41406
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbYL0Iyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 03:54:50 -0500
Date: Sat, 27 Dec 2008 00:54:52 -0800 (PST)
Message-Id: <20081227.005452.261413194.davem@davemloft.net>
To: sam@ravnborg.org
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org, mingo@elte.hu,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, kenchen@google.com,
       paulus@samba.org, tglx@linutronix.de, hpa@zytor.com,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] sparc64: use unsigned long long for u64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081223131746.GA7456@uranus.ravnborg.org>
References: <20081222230035.GB4074@uranus.ravnborg.org>
	<20081222151338.3b6ef997.akpm@linux-foundation.org>
	<20081223131746.GA7456@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mBR8t5ki007119

From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 23 Dec 2008 14:17:46 +0100

> It may take a few days before the drivers gets fixed.
> Christmas is approaching fast by now.

Even with this and your driver patch applied, the tree
doesn't build successfully:

cc1: warnings being treated as errors
arch/sparc/kernel/psycho_common.c: In function â€˜psycho_check_stc_errorâ€™:
arch/sparc/kernel/psycho_common.c:104: warning: format â€˜%016lxâ€™ expects type â€˜long unsigned intâ€™, but argument 4 has type â€˜long long unsigned intâ€™

Did you remove sparc's -Werror when doing test builds
of these changes? :-)

Either way these need some work before they should be
added to any tree.

Andrew you probably want to toss these from your tree
since at a minimum they will break the sparc64 build.

Sam will fix them up and resubmit, and I'll apply them,
don't worry. :)

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
