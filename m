Return-Path: <linux-kernel-owner+w=401wt.eu-S1751148AbZKGGUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148AbZKGGUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 01:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZKGGUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 01:20:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51914
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbZKGGUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 01:20:06 -0500
Date: Fri, 06 Nov 2009 22:20:32 -0800 (PST)
Message-Id: <20091106.222032.02604670.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       sparclinux@vger.kernel.org
Subject: Re: [patch 14/16] sparc: Replace old style lock initializer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091106.221834.246946954.davem@davemloft.net>
References: <20091106223547.784916750@linutronix.de>
	<20091106223806.973326715@linutronix.de>
	<20091106.221834.246946954.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nA76KP16032137

From: David Miller <davem@davemloft.net>
Date: Fri, 06 Nov 2009 22:18:34 -0800 (PST)

> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Fri, 06 Nov 2009 22:42:14 -0000
> 
>> SPIN_LOCK_UNLOCKED is deprecated. Use __SPIN_LOCK_UNLOCKED instead.
>> 
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Applied to sparc-next-2.6, thanks.

This breaks the build:

/home/davem/src/GIT/sparc-next-2.6/arch/sparc/include/asm/rwsem.h:39: error: expected identifier or â€˜(â€™ before â€˜{â€™ token
/home/davem/src/GIT/sparc-next-2.6/arch/sparc/include/asm/rwsem.h:39: error: expected identifier or â€˜(â€™ before â€˜}â€™ token
make[1]: *** [arch/sparc/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
