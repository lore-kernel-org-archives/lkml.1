Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbYGRL52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbYGRL52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbYGRL5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:57:05 -0400
Received: from styx.suse.cz ([82.119.242.94]:60105 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755594AbYGRL5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:57:03 -0400
Subject: Re: [PATCH 01/23] tracehook: add linux/tracehook.h
From: Petr Tesarik <ptesarik@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080717133426.GA9577@infradead.org>
References: <20080717072541.F390E15411D@magilla.localdomain>
	 <20080717072755.E2FBC15411D@magilla.localdomain>
	 <20080717084818.GA5637@martell.zuzino.mipt.ru>
	 <20080717133426.GA9577@infradead.org>
Content-Type: text/plain
Organization: SUSE LINUX
Date: Fri, 18 Jul 2008 13:57:00 +0200
Message-Id: <1216382220.16208.26.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 09:34 -0400, Christoph Hellwig wrote:
> On Thu, Jul 17, 2008 at 12:48:18PM +0400, Alexey Dobriyan wrote:
> > > The new linux/ptrace.h inlines are used by the following patches in the
> > > new tracehook_*() inlines.  Using these helpers for the ptrace event
> > > stops makes it simple to change or disable the old ptrace implementation
> > > of these stops conditionally later.
> > 
> > Call them "utrace_*" from the start?
> 
> Yes, please.
> 
> > Pointless 1:1 wrapper unless you're going to #ifdef ->ptrace later.
> 
> Even then I don't think it's a good idea.  This one should only be
> touched in very very few places

So, do you suggest putting those #ifdef's in the middle of the function
which uses it? Anyway, this patch should probably be posted later, i.e.
when the other implementation is actually introduced.

My $0.02.

Petr


