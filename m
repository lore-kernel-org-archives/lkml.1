Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbXCUW6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbXCUW6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbXCUW6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:58:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38498 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753064AbXCUW6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:58:30 -0400
Date: Wed, 21 Mar 2007 23:58:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lukas Hejtmanek <xhejtman@mail.muni.cz>, linux-kernel@vger.kernel.org
Subject: Re: Suspend to disk bug 2.6.21-rc2-git1
Message-ID: <20070321225820.GM6057@elf.ucw.cz>
References: <20070305132331.GF3693@mail.muni.cz> <20070321213007.GA3637@mail.muni.cz> <20070321223908.GI6057@elf.ucw.cz> <200703212359.41523.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703212359.41523.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > I'm not sure what version did exacly caused susped to disk problems but
> > > > > anyway, in 2.6.21-rc2-git1, suspend to disk breaks ACPI. ACPI events do not
> > > > > even emit ACPI interrupts. Suspend to ram works nicely.
> > > > 
> > > > Is 2.6.21-latest better?  There were many problems in suspend area,
> > > > hopefully they are slowly being fixed...
> > > 
> > > I've found out that only platform method is working. reboot method does not.
> > 
> > Try this one.
> 
> Good idea.
> 
> BTW, we didn't use "platform" during the resume in 2.6.20, so I think this
> patch should go into 2.6.21.

Yes, I think so. Do you or I do the akpm submission?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
