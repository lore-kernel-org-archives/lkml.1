Return-Path: <linux-kernel-owner+w=401wt.eu-S1759899AbXIXPi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbXIXPi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbXIXPiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:38:21 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51914 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbXIXPiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:38:19 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 24 Sep 2007 08:38:13 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/3] new timerfd API - wire the new timerfd API to the
 x86 family
In-Reply-To: <46F75E4D.2080209@gmx.net>
Message-ID: <Pine.LNX.4.64.0709240835030.23830@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.19354.1190587750.2>
 <46F75E4D.2080209@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007, Michael Kerrisk wrote:

> Davide,
> 
> Is it perhaps not better to group the three syscalls contiguously with
> respect to syscall numbers?  The old timerfd slot can be re-used for some
> other syscall later.

There's no problem if they're not contiguous. Holes, unless filled 
immediately, need to be remembered to be filled.


- Davide


