Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbZAaTDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbZAaTDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 14:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbZAaTDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 14:03:10 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:45030 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZAaTDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 14:03:09 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 31 Jan 2009 11:03:07 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 3/7] epoll keyed wakeups - introduce key-aware wakeup
 macros
In-Reply-To: <20090131092509.7c658b22@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.1.10.0901311101070.18888@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.16376.1233372317.3> <20090131033035.GA26640@elte.hu> <20090131092509.7c658b22@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009, Alan Cox wrote:

> > One minor worry i have: these wakeup calls are _very_ common in the 
> > kernel, and this patch adds an extra parameter to it that is unused (NULL) 
> > in 99% of the cases.
> 
> And in most of the cases it is used is constant for the waitqueue anyway
> or appears to be (eg the tty patch). I don't think we should be stacking
> extra parameters on all those zillions of calls made all over the kernel
> and for no purpose - so the existing wakeup functions should stay as is
> for performance as well as for size (which due to cache pressure is
> performance).

Besides for that, did the TTY patch look sane to you? Did I get all the 
wakeup points? TTY code always gave me the willies :)


- Davide


