Return-Path: <linux-kernel-owner+w=401wt.eu-S932868AbXBPBbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbXBPBbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 20:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932870AbXBPBbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 20:31:18 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42324 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438AbXBPBbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 20:31:17 -0500
Date: Thu, 15 Feb 2007 17:31:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparse chokes on arch/i386/kernel/i8253.c
Message-Id: <20070215173108.0fbd56ea.akpm@linux-foundation.org>
In-Reply-To: <20070216005804.GA12736@Krystal>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<45D483D7.2040609@imap.cc>
	<20070215144142.0c13580a.akpm@linux-foundation.org>
	<20070216002347.GB9851@Krystal>
	<20070215163709.720c38f0.akpm@linux-foundation.org>
	<20070216005804.GA12736@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 19:58:04 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > > 
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -309,7 +309,8 @@ AFLAGS_KERNEL	=
> > >  LINUXINCLUDE    := -Iinclude \
> > >                     $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
> > >  		   -include include/linux/autoconf.h \
> > > -		   -include linux/marker.h
> > > +		   -include \
> > > +		   	$(if $(KBUILD_SRC),$(srctree)/)include/linux/marker.h
> > >  
> > >  CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)
> > 
> > But what is so magical about marker.h to justify special-case treatment at the
> > kbuid level?
> 
> Idealistically speaking, nothing. It is however much easier to maintain
> an external set of patches introducing markers within the kernel tree :
> most of the rejects between kernel version comes from new includes that
> comes in the way.
> 
> So this is there more by convenience than requirement.

No sale.  Let's kill it, please ;)
