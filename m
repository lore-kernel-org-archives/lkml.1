Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbZLHNdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbZLHNdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 08:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZLHNdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 08:33:08 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43011 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbZLHNdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 08:33:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WDYWTmRe5IHjGg7ZZvb1LLX2P+KtLXSw3YPth+ECVe8wxvH5Esp+2rvHw6Gjr2LQ0x
         UajzyMqCcBWiYQAYgh7lIepcH40dJEUmCvIH30O+pPIWzBNAByGKY2QeuMGAiljFc2oE
         Z9tTmo5zc4XJkTztE4gMZ26j2mMubTUJUbAgI=
MIME-Version: 1.0
In-Reply-To: <20091206111957.651783909@linutronix.de>
References: <20091206110944.492100233@linutronix.de>
	 <20091206111957.651783909@linutronix.de>
Date: Tue, 8 Dec 2009 21:33:13 +0800
Message-ID: <2674af740912080533o12878af5ve2fb88e5e1c0a286@mail.gmail.com>
Subject: Re: [patch 09/23] locking: Implement new raw_spinlock
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 7, 2009 at 2:02 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Now that the raw_spin name space is freed up, we can implement
> raw_spinlock and the related functions which are used to annotate the
> locks which are not converted to sleeping spinlocks in preempt-rt.
>
> A side effect is that only such locks can be used with the low level
> lock fsunctions which circumvent lockdep.

s/fsunctions/functions
