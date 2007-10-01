Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbXJAHsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbXJAHsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 03:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXJAHsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 03:48:46 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49169 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbXJAHsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 03:48:46 -0400
Date: Mon, 1 Oct 2007 09:50:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch and kernel/sched.c
Message-ID: <20071001075014.GB23965@uranus.ravnborg.org>
References: <20070928105345.GC18163@shadowen.org> <20071001064448.GA4239@elte.hu> <20071001003007.4e90143b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001003007.4e90143b.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > > WARNING: externs should be avoided in .c files
> > > #6545: FILE: home/apw/git/linux-2.6/kernel/sched.c:6542:
> > > +	extern char __sched_text_start[], __sched_text_end[];
> > > 
> > > That one ... dunno.  This check is a difficult one.  Should it be a 
> > > CHECK?
> > 
> > no, this is a legitimate warning - externs in .c files should move into 
> > the proper .h file. So i'd suggest to keep this a WARNING.
> 
> Yes.  When the symbol is defined in .S or vmlinux.lds we have
> traditionally declared it in .c.
> 
> But why?  It _is_ a global symbol.  We might as well declare it in .h. 
> That's consistent, and prevents duplicated declarations from popping up
> later on.
It would be nice to collect all linker symbol externs in one place..
asm-$(ARCH)/???.h

We could even auto-generate it but thats not worth it I think.

	Sam
