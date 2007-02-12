Return-Path: <linux-kernel-owner+w=401wt.eu-S965005AbXBLQww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965005AbXBLQww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964974AbXBLQwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:52:40 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54777 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965005AbXBLQwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:52:21 -0500
Date: Mon, 12 Feb 2007 17:52:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Manu Abraham <abraham.manu@gmail.com>, Willy Tarreau <w@1wt.eu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070212165207.GC17400@elf.ucw.cz>
References: <1171059433.8675.195.camel@laptopd505.fenrus.org> <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl> <1171147026.19894.16.camel@nigel.suspend2.net> <20070211064636.GA12171@1wt.eu> <1171234027.4493.88.camel@nigel.suspend2.net> <1a297b360702111457k3a38eefei485f814f980e58c6@mail.gmail.com> <1171236000.4493.116.camel@nigel.suspend2.net> <1a297b360702111525v4f26ad4ax9af8fba45936c22f@mail.gmail.com> <1171236787.4493.132.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171236787.4493.132.camel@nigel.suspend2.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > Neither am I. I'm just asking that new drivers have power management as
> > > > > standard.
> > >
> > > > What if the hardware doesn't support power management ?
> > >
> > > You would still want to do the cleanup and configuration that you'd do
> > > for module load/unload.
> > >
> > By adding dummy functions, wouldn't that just look awkward ?
> 
> If all you need to do is say 'I don't need to do anything' and we have a
> shared function that does that, all we're talking about doing is adding
> to your struct pci_device (or whatever)
> 
> .resume = generic_empty_resume;
> 
> To me at least, that doesn't look awkward, and says cleanly and clearly
> that you've checked things over and decided you know what's required.

Actually, I'd like it to be

.resume = generic_empty_resume; /* Explain, why your driver needs no
				   resume */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
