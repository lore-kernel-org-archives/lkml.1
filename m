Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbZBKEDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbZBKEDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 23:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbZBKEDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 23:03:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:32896 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbZBKEDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 23:03:45 -0500
Subject: Re: [PATCH 1/3] Makefile: Include arch Makefiles as late as
 possible
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Sam Ravnborg <sam@ravnborg.org>, Steven Rostedt <srostedt@redhat.com>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20090204212612.GN22608@elte.hu>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru>
	 <20090204150835.GA30027@oksana.dev.rtsoft.ru>
	 <20090204212612.GN22608@elte.hu>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 14:51:34 +1100
Message-Id: <1234324294.29851.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 22:26 +0100, Ingo Molnar wrote:
> > +include $(srctree)/arch/$(SRCARCH)/Makefile
> > +
> >  # arch Makefile may override CC so keep this after arch Makefile is
> included
> >  NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC)
> -print-file-name=include)
> >  CHECKFLAGS     += $(NOSTDINC_FLAGS)
> > -- 
> 
> this patch is really for Sam to judge - Cc:-ed him.

Sam ? I have a few more powerpc patches depending on that one... so I'd
like to know if it's totally doomed or not :-)

Cheers,
Ben.



