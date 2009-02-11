Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbZBKOMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbZBKOMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZBKOMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:12:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZBKOMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:12:25 -0500
Subject: Re: [PATCH 1/3] Makefile: Include arch Makefiles as late as
	possible
From: Steven Rostedt <srostedt@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Sam Ravnborg <sam@ravnborg.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <20090211132338.GQ16535@elte.hu>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru>
	 <20090204150835.GA30027@oksana.dev.rtsoft.ru>
	 <20090204212612.GN22608@elte.hu> <1234324294.29851.0.camel@pasglop>
	 <20090211132338.GQ16535@elte.hu>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 11 Feb 2009 09:11:42 -0500
Message-Id: <1234361502.31601.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-02-11 at 14:23 +0100, Ingo Molnar wrote:
> * Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > On Wed, 2009-02-04 at 22:26 +0100, Ingo Molnar wrote:
> > > > +include $(srctree)/arch/$(SRCARCH)/Makefile
> > > > +
> > > >  # arch Makefile may override CC so keep this after arch Makefile is
> > > included
> > > >  NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC)
> > > -print-file-name=include)
> > > >  CHECKFLAGS     += $(NOSTDINC_FLAGS)
> > > > -- 
> > > 
> > > this patch is really for Sam to judge - Cc:-ed him.
> > 
> > Sam ? I have a few more powerpc patches depending on that one... so I'd
> > like to know if it's totally doomed or not :-)
> 
> Well, toplevel Makefile changes are not to be taken lightly :-)
> 
> Looks good to me but it's handy to have Sam's Ack on it too.
> 

Someone on IRC said that Sam is on vacation. This could take a while for
an ACK.


-- Steve


