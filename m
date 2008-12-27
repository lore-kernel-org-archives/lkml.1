Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbYL0R1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbYL0R1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 12:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYL0R1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 12:27:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:49579 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbYL0R1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 12:27:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LgR+eVwHfc+78LSJ7502BobmLMZBLCmXQxrtEE6zHoOVM1YriZIfojZbqGlZeAlXD6
         +O5ofL+nONrs/pNExYuKd4JaqdxTEm5mhuWMMVL0PWC6J4xaSSaune3TRpUypf5svVSk
         LKAN11IW0C91n0FnaiHpcShh6J02s4lXzjFDY=
Message-ID: <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com>
Date: Sun, 28 Dec 2008 02:27:43 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <20081227133240.GA8716@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ------------------>
> Ingo Molnar (2):
>      sparseirq: do not printk when migrating IRQ descriptors
>      sparseirq: fix desc->lock init
>
> KOSAKI Motohiro (4):
>      hrtimer: remove #include <linux/irq.h>
>      irq: for_each_irq_desc() move to irqnr.h
>      proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
>      irq: simplify for_each_irq_desc() usage
>
> Yinghai Lu (4):
>      sparseirq: remove duplicated arch_early_irq_init()
>      sparseirq: work around compiler optimizing away __weak functions

Unfortunately, this workaround doesn't workaround.
Kamalesh reported kernel still crashes.

So, I suggest to pending this pull request awhile.
Nobody want to merge pseudo fix.



>      sparseirq: fix hang with !SPARSE_IRQ
>      sparseirq: set lock_class for legacy irq when sparse_irq is selected
