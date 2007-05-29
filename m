Return-Path: <linux-kernel-owner+w=401wt.eu-S1764933AbXE2LaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764933AbXE2LaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbXE2L35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:29:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54741 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756172AbXE2L34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:29:56 -0400
Date: Tue, 29 May 2007 13:29:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
Message-ID: <20070529112952.GA23046@elf.ucw.cz>
References: <4658B7DD.3060309@tmr.com> <465AD746.7090008@tmr.com> <20070528132625.GQ18807@elf.ucw.cz> <200705281957.38954.rjw@sisk.pl> <1180392482.4149.15.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180392482.4149.15.camel@nigel.suspend2.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yup.  Don't we do something like this for the (ACPI-based) suspend to RAM
> > already?
> 
> Yeah, I was thinking about this overnight too. It should be doable. In
> addition to what we already do, I think you'd want:
> 
> - to copy the assembly to do the copying to a safe page;
> - to put the location of the cpu state that was saved in the image
> header so that it can be used after the data is copied back;

...alternatively, we can just rely on copy routine (and its data) not
changing frequently.

> - to copy the nosave data to a 'safe' page.
> 
> What else?

page directories need to be on a safe place, too.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
