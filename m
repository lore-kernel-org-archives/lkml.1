Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbXBJV6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbXBJV6Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 16:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXBJV6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 16:58:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4946 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751958AbXBJV6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 16:58:24 -0500
Date: Sat, 10 Feb 2007 19:38:52 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: nigel@nigel.suspend2.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070210193851.GA3956@ucw.cz>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171059433.8675.195.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171059433.8675.195.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I don't think this is already done (feel free to correct me if I'm
> > wrong)..
> > 
> > Can we start to NAK new drivers that don't have proper power management
> > implemented? There really is no excuse for writing a new driver and not
> > putting .suspend and .resume methods in anymore, is there?
> 
> to a large degree, a device driver that doesn't suspend is better than
> no device driver at all, right?
> now.. if you want to make the core warn about it, that's very fair

Well, driver that is broken on SMP is arguably better than no driver
at all, yet we'd probably avoid merging that. It would be nice to
start including suspend in 'must work' list...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
