Return-Path: <linux-kernel-owner+w=401wt.eu-S965430AbXBFUjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965430AbXBFUjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965433AbXBFUja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:39:30 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3963 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965416AbXBFUja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:39:30 -0500
Date: Tue, 6 Feb 2007 20:39:15 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Denis Vlasenko <vda.linux@googlemail.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Linus Torvalds <torvalds@osdl.org>, Viktor <vvp01@inbox.ru>,
       Aubrey <aubreylee@gmail.com>, Hua Zhong <hzhong@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org, kenneth.w.chen@in.karlin.mff.cuni.cz
Subject: Re: O_DIRECT question
Message-ID: <20070206203914.GA4128@ucw.cz>
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701252211.39017.vda.linux@googlemail.com> <45BA34EE.4050402@cfl.rr.com> <200701270016.46951.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701270016.46951.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Which shouldn't be true. There is no fundamental reason why
> > > ordinary writes should be slower than O_DIRECT.
> > 
> > Again, there IS a reason:  O_DIRECT eliminates the cpu overhead of the 
> > kernel-user copy,
> 
> You assume that ordinary read()/write() is *required* to do the copying.
> It doesn't. Kernel is allowed to do direct DMAing in this case too.

Kernel is allowed, but it is practically impossible to code. It would
require slow MMU magic.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
