Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbXE0VBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbXE0VBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbXE0VA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:00:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2052 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316AbXE0VA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:00:27 -0400
Date: Fri, 25 May 2007 06:46:44 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the	-stable cycle
Message-ID: <20070525064644.GC3989@ucw.cz>
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com> <46533EA8.7020602@garzik.org> <20070524100455.GB7444@ucw.cz> <465563B4.5040301@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465563B4.5040301@garzik.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Well, in 2.6.73.1 we add 'trivial' one line to add new 
> >pci id, and in
> >2.6.73.2 we have data corruption, because that driver 
> >needed some
> >quirk we did not know about...?
> 
> False argument.  -stable should only be merging patches 
> that are already upstream, and known.

Well, then we should have some more requirements. 'Has been in
-rc2-git1 for 8 hours' is technically upstream, but it does not make
the patch 'known-enough' for stable. 'Have been in three release
candidates' seems like a rule we want here.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
