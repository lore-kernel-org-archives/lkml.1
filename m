Return-Path: <linux-kernel-owner+w=401wt.eu-S933660AbXDARIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660AbXDARIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 13:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933679AbXDARIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 13:08:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:48861 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933660AbXDARIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 13:08:51 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 1 Apr 2007 10:08:50 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 6/13] signal/timer/event fds v9 - timerfd core ...
In-Reply-To: <Pine.LNX.4.64.0704010941490.26331@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0704011007570.26331@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.16816.1175371772.6>
 <1175418341.28263.64.camel@localhost.localdomain>
 <Pine.LNX.4.64.0704010941490.26331@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007, Davide Libenzi wrote:

> I do not know about DoS on timers (did not follow the thread), but I could 
> easily implement it here, by capping the counter to some value, and return 
> POLLERR in poll().

For capping I mean, I won't re-arm the timer if ticks exceeded it ...


- Davide


