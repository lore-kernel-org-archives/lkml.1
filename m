Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbZCUDK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbZCUDK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 23:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZCUDKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 23:10:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43937 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbZCUDKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 23:10:46 -0400
Subject: Re: [PATCH] tracing: Fix TRACING_SUPPORT dependency
From: Steven Rostedt <srostedt@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, dale@farnsworth.org
In-Reply-To: <20090320195743.GA25147@elte.hu>
References: <20090320150914.GA22769@oksana.dev.rtsoft.ru>
	 <20090320190428.GD6224@elte.hu>
	 <20090320193904.GA13707@oksana.dev.rtsoft.ru>
	 <20090320195743.GA25147@elte.hu>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 20 Mar 2009 23:09:58 -0400
Message-Id: <1237604998.17367.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ug, My Red Hat email was not being updated. I totally missed this
thread.

On Fri, 2009-03-20 at 20:57 +0100, Ingo Molnar wrote:
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

I've discussed this with several people before. lockdep exists for
PPC64, but apparently it does not work for PPC32. There's been ongoing
work in this area, but unfortunately, nothing stable has come out of it.

I believe Dale was the last one to be working on this.

-- Steve


