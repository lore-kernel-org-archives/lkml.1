Return-Path: <linux-kernel-owner+w=401wt.eu-S1761365AbYESQQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365AbYESQQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYESQQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:16:12 -0400
Received: from www.tglx.de ([62.245.132.106]:57592 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbYESQQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:16:10 -0400
Date: Mon, 19 May 2008 18:15:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: tip build broken on sparc64...
In-Reply-To: <20080519153042.GB2000@elte.hu>
Message-ID: <alpine.LFD.1.10.0805191814260.18798@apollo.tec.linutronix.de>
References: <20080516.130758.138657725.davem@davemloft.net> <20080519153042.GB2000@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Ingo Molnar wrote:
> * David Miller <davem@davemloft.net> wrote:
> 
> > It's this pteval_t stuff, probably breaks just about every
> > other platforms as well.
> > 
> > Please fix this, because I'd like to work on some ftrace
> > optimizations on sparc64, and do some testing of ftrace
> > in general.
> > 
> > mm/mmap.c: In function 'vm_get_page_prot_preserve':
> > mm/mmap.c:86: error: 'pteval_t' undeclared (first use in this function)
> > mm/mmap.c:86: error: (Each undeclared identifier is reported only once
> > mm/mmap.c:86: error: for each function it appears in.)
> > mm/mmap.c:86: error: expected ';' before 'newprotval'
> > mm/mmap.c:88: error: 'newprotval' undeclared (first use in this function)
> 
> ok, will take care of it now.

That was a conflict of mprotect patches, which is resolved. Just
checked that current -tip builds a sparc64 defconfig.

Thanks,	

	tglx
