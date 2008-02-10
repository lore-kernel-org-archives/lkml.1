Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYBJHgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYBJHgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbYBJHgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:36:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49957
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754227AbYBJHgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:36:45 -0500
Date: Sat, 09 Feb 2008 23:37:16 -0800 (PST)
Message-Id: <20080209.233716.152271295.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@zip.com.au, tglx@linutronix.de, jason.wessel@windriver.com
Subject: Re: [0/6] kgdb light
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080210071304.GA3788@elte.hu>
References: <20080210071304.GA3788@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 10 Feb 2008 08:13:04 +0100

> this is the "kgdb light" tree that has been also posted at:
> 
>    http://lkml.org/lkml/2008/2/9/236
> 
> it is available at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git
> 
> See the shortlog below.

Thanks for keeping this work alive.

>  - removed the GTOD/clocksource hacks. If a user uses kdgb for extended
>    periods of time then GTOD clocksources can get out of sync and we
>    might fall back to other clocksources. That is the _right_ thing to 
>    do for the kernel, hacking it around to avoid kernel messages was
>    wrong.

I suspect something will however need to be done with watchdogs
and things of that nature which will get very confused if the
kernel sits in a breakpoint for a period of time whilst the user
looks at things from the kgdb prompt.

Just a heads up...
