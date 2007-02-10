Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbXBJIlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbXBJIlx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 03:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbXBJIlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 03:41:53 -0500
Received: from brick.kernel.dk ([62.242.22.158]:10646 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbXBJIlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 03:41:52 -0500
Date: Sat, 10 Feb 2007 09:42:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Otavio Salvador <otavio@debian.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add PM_TRACE x86_64 support.
Message-ID: <20070210084217.GJ6152@kernel.dk>
References: <1170895857.4451.55.camel@nigel.suspend2.net> <87lkj9bg67.fsf@neumann.lab.ossystems.com.br> <1170900487.4451.62.camel@nigel.suspend2.net> <20070208124003.GE4487@kernel.dk> <20070209225255.GC3949@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070209225255.GC3949@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09 2007, Pavel Machek wrote:
> Hi!
> 
> > > > Nigel Cunningham <nigel@nigel.suspend2.net> writes:
> > > > 
> > > > > -	for (tracedata = &__tracedata_start ; tracedata < &__tracedata_end ; tracedata += 6) {
> > > > > +	for (tracedata = &__tracedata_start ; tracedata < &__tracedata_end ; tracedata += 2 + sizeof(unsigned long)) {
> > > > 
> > > > Could you split this line?
> > > 
> > > Sure.
> > > 
> > > -- New version -- (What's the right way to do this?)
> > > 
> > > This patch add x86_64 support for PM_TRACE, and shifts per-arch code to
> > > the appropriate subdirectories.
> > > 
> > > Symbol exports are added so tracing can be used from drivers built as
> > > modules too.
> > 
> > Don't include exports in a patch that doesn't use them. Introduce the
> > exports in a later patch series, for when you actually need it.
> 
> It is debugging infrastructure, so export actually makes sense... It
> will not ever be used in mainline kernel; you need to modify code
> manually to use this code..

Then add the exports while you are modifying the other code, it's no
reason to put it in mainline.

-- 
Jens Axboe

