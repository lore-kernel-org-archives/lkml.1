Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZCTUW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZCTUW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZCTUWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:22:49 -0400
Received: from [213.79.90.228] ([213.79.90.228]:41799 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751868AbZCTUWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:22:49 -0400
Date: Fri, 20 Mar 2009 23:22:47 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: Fix TRACING_SUPPORT dependency
Message-ID: <20090320202247.GA30654@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090320150914.GA22769@oksana.dev.rtsoft.ru> <20090320190428.GD6224@elte.hu> <20090320193904.GA13707@oksana.dev.rtsoft.ru> <20090320195743.GA25147@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090320195743.GA25147@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 08:57:43PM +0100, Ingo Molnar wrote:
> 
> * Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > On Fri, Mar 20, 2009 at 08:04:28PM +0100, Ingo Molnar wrote:
> > > 
> > > * Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> > > 
> > > > commit 40ada30f9621fbd831ac2437b9a2a399aad34b00 ("tracing: clean 
> > > > up menu"), despite the "clean up" in its purpose, introduced 
> > > > behavioural change for Kconfig symbols: we no longer able to 
> > > > select tracing support on PPC32 (because IRQFLAGS_SUPPORT isn't 
> > > > yet implemented).
> > > 
> > > Could you please solve this by implementing proper 
> > > irqflag-tracing support? It's been available upstream for almost 
> > > three years. It's needed for lockdep support as well, etc.
> > 
> > Breaking things via clean up patches is an interesting method of 
> > encouraging something to implement. ;-)
> >
> > Surely I'll look into implementing irqflags tracing, but 
> > considering that no one ever needed this for almost three years, 
> > [...]
> 
> Weird, there's no lockdep support?

*ashamed*: apparently no such support currently exist for PPC32. ;-)

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
