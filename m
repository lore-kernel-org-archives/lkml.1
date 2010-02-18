Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab0BRMJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 07:09:48 -0500
Received: from mtagate6.de.ibm.com ([195.212.17.166]:38841 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab0BRMJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 07:09:46 -0500
Date: Thu, 18 Feb 2010 13:09:45 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] tracing/kprobes: Make Kconfig dependencies generic
Message-ID: <20100218120944.GA2406@osiris.boeblingen.de.ibm.com>
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com>
 <1266491616-6270-3-git-send-regression-fweisbec@gmail.com>
 <8bd0f97a1002180318g6ce70480x571d7d332239d68b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a1002180318g6ce70480x571d7d332239d68b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 06:18:20AM -0500, Mike Frysinger wrote:
> On Thu, Feb 18, 2010 at 06:13, Frederic Weisbecker wrote:
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -121,6 +121,9 @@ config HAVE_DMA_ATTRS
> >  config USE_GENERIC_SMP_HELPERS
> >        bool
> >
> > +config HAVE_REGS_AND_STACK_ACCESS_API
> > +       bool
> > +
> 
> could you add an appropriate help/comment so arch peeps know what
> needs to be implemented before they can select this

That's why I added the commit ID for the regs and stack access api
to the changelog. imho that should be sufficient.
Besides that the next commit would implement it for s390 as a
blueprint for others. That is... for those that missed the initial
x86 implementation.
