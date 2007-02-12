Return-Path: <linux-kernel-owner+w=401wt.eu-S964955AbXBLPEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964955AbXBLPEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 10:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964953AbXBLPEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 10:04:34 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49417 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964955AbXBLPEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 10:04:33 -0500
Date: Mon, 12 Feb 2007 16:04:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       nigel@nigel.suspend2.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070212150410.GA17400@elf.ucw.cz>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171059433.8675.195.camel@laptopd505.fenrus.org> <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl> <Pine.LNX.4.62.0702120948230.10436@chinchilla.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0702120948230.10436@chinchilla.sonytel.be>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > "If the device requires that, implement .suspend and .resume or at least
>                                                                   ^^^^^^^^
> > define .suspend that will always return -ENOSYS (then people will know they
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > have to unload the driver before the suspend).  Similarly, if you aren't sure
> > whether or not the device requires .suspend and .resume, define .suspend that
>                                                            ^^^^^^^^^^^^^^^^^^^^
> > will always return -ENOSYS."
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Can't the upper layer just assume -ENOSYS if .resume/.suspend is NULL?
> It's nicer if you don't have to implement dummy functions at all.

Unfortunately, drivers currently assume "NULL == nothing is needed",
so we'd have t do big search & replace... 
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
