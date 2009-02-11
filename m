Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbZBKNYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbZBKNYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZBKNYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:24:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36469 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbZBKNYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:24:03 -0500
Date: Wed, 11 Feb 2009 14:23:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Sam Ravnborg <sam@ravnborg.org>, Steven Rostedt <srostedt@redhat.com>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 1/3] Makefile: Include arch Makefiles as late as
	possible
Message-ID: <20090211132338.GQ16535@elte.hu>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru> <20090204150835.GA30027@oksana.dev.rtsoft.ru> <20090204212612.GN22608@elte.hu> <1234324294.29851.0.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234324294.29851.0.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2009-02-04 at 22:26 +0100, Ingo Molnar wrote:
> > > +include $(srctree)/arch/$(SRCARCH)/Makefile
> > > +
> > >  # arch Makefile may override CC so keep this after arch Makefile is
> > included
> > >  NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC)
> > -print-file-name=include)
> > >  CHECKFLAGS     += $(NOSTDINC_FLAGS)
> > > -- 
> > 
> > this patch is really for Sam to judge - Cc:-ed him.
> 
> Sam ? I have a few more powerpc patches depending on that one... so I'd
> like to know if it's totally doomed or not :-)

Well, toplevel Makefile changes are not to be taken lightly :-)

Looks good to me but it's handy to have Sam's Ack on it too.

	Ingo
