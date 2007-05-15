Return-Path: <linux-kernel-owner+w=401wt.eu-S1760547AbXEPNfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760547AbXEPNfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbXEPNfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:35:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2056 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754403AbXEPNfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:35:30 -0400
Date: Tue, 15 May 2007 08:23:11 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Hellwig <hch@infradead.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Dan Aloni <da-x@monatomic.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow kernel module exclusion on load
Message-ID: <20070515082311.GA6816@ucw.cz>
References: <20070513132517.GA14038@localdomain> <20070513092352.18cd80de@freepuppy> <20070513182035.GA10207@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513182035.GA10207@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-05-13 19:20:35, Christoph Hellwig wrote:
> On Sun, May 13, 2007 at 09:23:52AM -0700, Stephen Hemminger wrote:
> > On Sun, 13 May 2007 16:25:17 +0300
> > Dan Aloni <da-x@monatomic.org> wrote:
> > 
> > > Kernel developers might find it useful for quickly getting out from some 
> > > rough debugging scenarios.
> > > 
> > > Signed-off-by: Dan Aloni <da-x@monatomic.org>
> > > 
> > 
> > There is already the modprobe blacklist ability in user space.
> 
> doesn't really help if hotplug loads a broken module before you're getting
> a login prompt.  So while this is a bit of a hack I'm all in favour of this.
> (Especially as I got hit by this issue again yesterday)

It is quite a bick hack. Unknown kernel parameters are passed to init,
can we just make modprobe parse that?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
