Return-Path: <linux-kernel-owner+w=401wt.eu-S1946549AbXBIX4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946549AbXBIX4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946544AbXBIXzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:55:38 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2815 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423355AbXBIXze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:55:34 -0500
Date: Fri, 9 Feb 2007 22:52:55 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Otavio Salvador <otavio@debian.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add PM_TRACE x86_64 support.
Message-ID: <20070209225255.GC3949@ucw.cz>
References: <1170895857.4451.55.camel@nigel.suspend2.net> <87lkj9bg67.fsf@neumann.lab.ossystems.com.br> <1170900487.4451.62.camel@nigel.suspend2.net> <20070208124003.GE4487@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208124003.GE4487@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Nigel Cunningham <nigel@nigel.suspend2.net> writes:
> > > 
> > > > -	for (tracedata = &__tracedata_start ; tracedata < &__tracedata_end ; tracedata += 6) {
> > > > +	for (tracedata = &__tracedata_start ; tracedata < &__tracedata_end ; tracedata += 2 + sizeof(unsigned long)) {
> > > 
> > > Could you split this line?
> > 
> > Sure.
> > 
> > -- New version -- (What's the right way to do this?)
> > 
> > This patch add x86_64 support for PM_TRACE, and shifts per-arch code to
> > the appropriate subdirectories.
> > 
> > Symbol exports are added so tracing can be used from drivers built as
> > modules too.
> 
> Don't include exports in a patch that doesn't use them. Introduce the
> exports in a later patch series, for when you actually need it.

It is debugging infrastructure, so export actually makes sense... It
will not ever be used in mainline kernel; you need to modify code
manually to use this code..

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
