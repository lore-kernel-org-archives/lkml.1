Return-Path: <linux-kernel-owner+w=401wt.eu-S1764745AbXE2MlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764745AbXE2MlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXE2Mk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:40:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46937 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751828AbXE2Mk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:40:56 -0400
Date: Tue, 29 May 2007 14:40:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
Message-ID: <20070529124052.GH23046@elf.ucw.cz>
References: <4658B7DD.3060309@tmr.com> <1180392482.4149.15.camel@nigel.suspend2.net> <20070529112952.GA23046@elf.ucw.cz> <200705291403.09773.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705291403.09773.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-05-29 14:03:07, Rafael J. Wysocki wrote:
> On Tuesday, 29 May 2007 13:29, Pavel Machek wrote:
> > Hi!
> > 
> > > > Yup.  Don't we do something like this for the (ACPI-based) suspend to RAM
> > > > already?
> > > 
> > > Yeah, I was thinking about this overnight too. It should be doable. In
> > > addition to what we already do, I think you'd want:
> > > 
> > > - to copy the assembly to do the copying to a safe page;
> > > - to put the location of the cpu state that was saved in the image
> > > header so that it can be used after the data is copied back;
> > 
> > ...alternatively, we can just rely on copy routine (and its data) not
> > changing frequently.
> > 
> > > - to copy the nosave data to a 'safe' page.
> > > 
> > > What else?
> > 
> > page directories need to be on a safe place, too.
> 
> They are already.

...but will that place still be safe when we use other version of
kernel?

Anyway, pagedirs are on the safe place, right? That means that we
swsusp should no longer clash with page allocation debugging... 
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
