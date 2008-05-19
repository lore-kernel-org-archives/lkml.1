Return-Path: <linux-kernel-owner+w=401wt.eu-S1763307AbYESUAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763307AbYESUAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762647AbYESUAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:00:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37342
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762497AbYESUAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:00:11 -0400
Date: Mon, 19 May 2008 13:00:06 -0700 (PDT)
Message-Id: <20080519.130006.77239937.davem@davemloft.net>
To: tglx@linutronix.de
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: tip build broken on sparc64...
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0805191814260.18798@apollo.tec.linutronix.de>
References: <20080516.130758.138657725.davem@davemloft.net>
	<20080519153042.GB2000@elte.hu>
	<alpine.LFD.1.10.0805191814260.18798@apollo.tec.linutronix.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 19 May 2008 18:15:43 +0200 (CEST)

> On Mon, 19 May 2008, Ingo Molnar wrote:
> > * David Miller <davem@davemloft.net> wrote:
> > 
> > > It's this pteval_t stuff, probably breaks just about every
> > > other platforms as well.
> > > 
> > > Please fix this, because I'd like to work on some ftrace
> > > optimizations on sparc64, and do some testing of ftrace
> > > in general.
> > > 
> > > mm/mmap.c: In function 'vm_get_page_prot_preserve':
> > > mm/mmap.c:86: error: 'pteval_t' undeclared (first use in this function)
> > > mm/mmap.c:86: error: (Each undeclared identifier is reported only once
> > > mm/mmap.c:86: error: for each function it appears in.)
> > > mm/mmap.c:86: error: expected ';' before 'newprotval'
> > > mm/mmap.c:88: error: 'newprotval' undeclared (first use in this function)
> > 
> > ok, will take care of it now.
> 
> That was a conflict of mprotect patches, which is resolved. Just
> checked that current -tip builds a sparc64 defconfig.

Thanks a lot.
