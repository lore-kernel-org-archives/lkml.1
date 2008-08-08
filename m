Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbYHHHwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbYHHHwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 03:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYHHHw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 03:52:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2608 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753027AbYHHHw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 03:52:26 -0400
Date: Fri, 8 Aug 2008 09:49:17 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Ben Collins <bcollins@swissdisk.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VT: Restore VT fonts on switch
Message-ID: <20080808074916.GB10657@ucw.cz>
References: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org> <20080721134327.3ffab96f@infradead.org> <1216673584.7585.189.camel@cunning> <20080721221204.1f3be45d@lxorguk.ukuu.org.uk> <20080721213735.GA11648@srcf.ucam.org> <20080721222428.20395240@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721222428.20395240@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > do you have a list of which ones don't ?
> > > > 
> > > > I don't, but perhaps Matthew does.
> > > 
> > > Perhaps Matthew would care to file X bugs against those that get it wrong
> > > then.
> > 
> > It's hardly limited to X. Fonts are set through the kernel - why 
> > shouldn't it be the kernel's responsibility to ensure that they're 
> > restored?
> 
> Why should it be the kernels problem to clean up after buggy X drivers ?
> 
> There are cases the kernel probably should handle font restore: the
> obvious one being suspend/resume. X is not one of those cases and wasting
> memory on fonts on embedded boxes that will never be seen anyway seems
> silly.
> 
> For suspend/resume it might be far better to do it in user space,
> although I'm not sure what the interface would look like.

This does not parse. 'kernel should handle font restore' .... 'but it
might be better to do that in userspace'.

Actually I'd prefer to do this in kernel, so it works in cases like
suspend self-test (done from kernel), from single user mode, etc...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
