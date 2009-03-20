Return-Path: <linux-kernel-owner+w=401wt.eu-S1760619AbZCTTjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760619AbZCTTjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZCTTjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:39:10 -0400
Received: from [213.79.90.228] ([213.79.90.228]:41721 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758710AbZCTTjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:39:09 -0400
Date: Fri, 20 Mar 2009 22:39:04 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: Fix TRACING_SUPPORT dependency
Message-ID: <20090320193904.GA13707@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090320150914.GA22769@oksana.dev.rtsoft.ru> <20090320190428.GD6224@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090320190428.GD6224@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 08:04:28PM +0100, Ingo Molnar wrote:
> 
> * Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > commit 40ada30f9621fbd831ac2437b9a2a399aad34b00 ("tracing: clean 
> > up menu"), despite the "clean up" in its purpose, introduced 
> > behavioural change for Kconfig symbols: we no longer able to 
> > select tracing support on PPC32 (because IRQFLAGS_SUPPORT isn't 
> > yet implemented).
> 
> Could you please solve this by implementing proper irqflag-tracing 
> support? It's been available upstream for almost three years. It's 
> needed for lockdep support as well, etc.

Breaking things via clean up patches is an interesting method of
encouraging something to implement. ;-)

Surely I'll look into implementing irqflags tracing, but considering
that no one ever needed this for almost three years, and that we
explicitly have the code to deal with tracing-w/o-irqflags, can we
please restore the old behaviour?

At least for 2.6.30, because I don't think I'll have enough time to
implement/test/push irqflags tracing support in time for 2.6.30-rc1.

Thanks,

p.s.
It would make more sense if 40ada30f's commit message would state
that tracing w/o irqflags is now obsolete, or better, if it was
discussed on some mailinglist, so that we'd have some time to
adapt the architecture-specific code.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
