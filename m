Return-Path: <linux-kernel-owner+w=401wt.eu-S932604AbXBKX3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbXBKX3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932721AbXBKX3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:29:53 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45421 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932604AbXBKX3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:29:53 -0500
Date: Mon, 12 Feb 2007 00:29:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: nigel@nigel.suspend2.net, Willy Tarreau <w@1wt.eu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070211232911.GI15445@elf.ucw.cz>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171059433.8675.195.camel@laptopd505.fenrus.org> <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl> <1171147026.19894.16.camel@nigel.suspend2.net> <20070211064636.GA12171@1wt.eu> <1171234027.4493.88.camel@nigel.suspend2.net> <1a297b360702111457k3a38eefei485f814f980e58c6@mail.gmail.com> <1171236000.4493.116.camel@nigel.suspend2.net> <1a297b360702111525v4f26ad4ax9af8fba45936c22f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a297b360702111525v4f26ad4ax9af8fba45936c22f@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > Neither am I. I'm just asking that new drivers have power management as
> >> > standard.
> >
> >> What if the hardware doesn't support power management ?
> >
> >You would still want to do the cleanup and configuration that you'd do
> >for module load/unload.
> >
> 
> By adding dummy functions, wouldn't that just look awkward ?

No, it is not by dummy functions. Checkout how swsusp works; it needs
no hw support, still it needs driver support.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
