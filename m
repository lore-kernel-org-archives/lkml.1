Return-Path: <linux-kernel-owner+w=401wt.eu-S936197AbXGTW0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936197AbXGTW0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760551AbXGTW0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:26:24 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:37409 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490AbXGTW0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:26:23 -0400
From: Markus <lists4me@web.de>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] CFS scheduler, -v19
Date: Sat, 21 Jul 2007 00:26:19 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070706173319.GA2356@elte.hu> <alpine.LFD.0.999.0707171329370.27353@woody.linux-foundation.org> <20070717204358.GA12037@elte.hu>
In-Reply-To: <20070717204358.GA12037@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707210026.19977.lists4me@web.de>
X-Provags-ID: V01U2FsdGVkX19tH0U8YCc48oRdiLD1v2C9cVuAPS5+kHNItyyE
	DWYs7XHMXfbO3ngs/D9pvnaoKlrCfGv2h9c0PgeEAlx71ic9FD
	hdIsBmwOw=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> hm, Markus indicated that he tried the v2.6.21.6-cfsv19 patch, and 
that 
> does not include the time.c change. Markus - does your kernel include 
> the code below? (if yes, please revert it via patch -p1 -R )

As already said, 2.6.22.1-cfs-v19 includes the patch and 
2.6.21.6-cfs-v19 does not include it.
But both suffer of the problem.

I now reversed the patch on 2.6.22.1-cfs-v19 but it does not help.
2.6.22-git15 is not working as well... so the problem did not magically 
disappear like the processes.

Any further things I can do to track it down? (I go on vacation on 
monday for two weeks, but just send them, I'll try them when I am back 
or answer the mails, when I dont need to build a new kernel...)


   Markus
