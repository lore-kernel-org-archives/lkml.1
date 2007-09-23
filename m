Return-Path: <linux-kernel-owner+w=401wt.eu-S1758419AbXIWSeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbXIWSeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 14:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbXIWSd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 14:33:57 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:45111 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077AbXIWSd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 14:33:56 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 23 Sep 2007 11:33:50 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: Ulrich Drepper <drepper@redhat.com>, geoff@gclare.org.uk,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@xenotime.net>,
       vda.linux@googlemail.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       =?X-UNKNOWN?Q?David_H=E4rdeman?= <david@hardeman.nu>
Subject: Re: RFC: A revised timerfd API
In-Reply-To: <46F6A37C.9010009@gmx.net>
Message-ID: <Pine.LNX.4.64.0709231128070.22989@alien.or.mcafeemobile.com>
References: <46EF7DDA.2070401@gmx.net> <Pine.LNX.4.64.0709180936480.22956@alien.or.mcafeemobile.com>
 <46F514C9.5010208@gmx.net> <Pine.LNX.4.64.0709221359190.22085@alien.or.mcafeemobile.com>
 <46F6A37C.9010009@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Sep 2007, Michael Kerrisk wrote:

> I applied this patch against 2.6.27-rc7, and wired up the syscalls as shown
> in the definitions below.  When I ran the the program below, my system
> immediately froze.  Can you try it on your system please.

There's an hrtimer_init() missing in timerfd_create(). I'll refactor the 
patch.



- Davide


