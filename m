Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbYFNXuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbYFNXuh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 19:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbYFNXu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 19:50:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:31587 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbYFNXuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 19:50:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=K2rJM06nPyJZ2tV2UB1pT6nGFzMYdb7OC80SBjw5ZcQIkykNjLvc1GxrheqvZpdLhn
         IsWZgTR1/Fx9IdFPyPI87l5cDUPWyiNSM8CJrVEsjiGA6fIddsH5tDAzYvUaFfMz6vo/
         hF8Woqe2SCfEmya7Q4zTb3iOWyE/OutQaTL3A=
Message-ID: <6278d2220806141650t520027ccw46d4ee936d101501@mail.gmail.com>
Date: Sun, 15 Jun 2008 00:50:24 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: 2.6.26-rc5: SLUB debug, lockdep warning...
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <19f34abd0806141423m18e35f29qb736d44460d70785@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806140354i7f163086i6127664d8c2d88a9@mail.gmail.com>
	 <19f34abd0806141423m18e35f29qb736d44460d70785@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 10:23 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Sat, Jun 14, 2008 at 12:54 PM, Daniel J Blueman
> <daniel.blueman@gmail.com> wrote:
>> When enabling lockdep + SLUB debugging, I spotted this recursive
>> lock-acquisition warning [1] when booting, however it doesn't always
>> pop out.
>
> This seems to be the work of
>
> commit 3ac7fe5a4aab409bd5674d0b070bce97f9d20872
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Wed Apr 30 00:55:01 2008 -0700
>
>    infrastructure to debug (dynamic) objects
>
> ...which by the way changed SLUB without any SOBs from any of the SLUB
> maintainers?

> Anyway, adding some Ccs.

Thanks for the detective work Vegard!

>> Let me know if you need further information etc.
>
> Exact kernel version and your config file would be useful (please post
> it online somewhere if possible). Thanks!

2.6.26-rc5 mainline, x86-64 dual-core with maximal debug, running
stock Ubuntu 8.04 desktop, NFSv4 home; seems to trigger always with
nscd loading on boot. Config at:

http://quora.org/slub-lockdep-config
-- 
Daniel J Blueman
