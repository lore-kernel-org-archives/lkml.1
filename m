Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbYJTXqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbYJTXqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYJTXp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:45:57 -0400
Received: from isilmar.linta.de ([213.133.102.198]:60297 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751767AbYJTXp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:45:56 -0400
Date: Tue, 21 Oct 2008 01:45:53 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
Subject: Re: [PATCH 1/3] Add file patterns to MAINTAINERS
Message-ID: <20081020234553.GA13115@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Pavel Machek <pavel@suse.cz>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
References: <1224541704-30357-1-git-send-email-joe@perches.com> <1224541704-30357-2-git-send-email-joe@perches.com> <20081020225058.GA7184@isilmar.linta.de> <1224543747.12101.66.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224543747.12101.66.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 04:02:26PM -0700, Joe Perches wrote:
> On Tue, 2008-10-21 at 00:50 +0200, Dominik Brodowski wrote:
> > Hi,
> > 
> > >  PCMCIA SUBSYSTEM
> > >  P:	Linux PCMCIA Team
> > >  L:	linux-pcmcia@lists.infradead.org
> > >  W:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
> > >  T:	git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
> > >  S:	Maintained
> > > +F:	Documentation/pcmcia/
> > > +F:	drivers/*/pcmcia/
> > > +F:	drivers/pcmcia/
> > > +F:	include/pcmcia/
> > > +F:	sound/pcmcia/
> > 
> > sound/pcmcia/ and lots of drivers/*/pcmcia is actually really
> > driver-related and not PCMCIA related so I'm not really happy if this will
> > be described by the PCMCIA F:-realm...
> 
> I generated that pattern from patchsets like:
> http://lists.infradead.org/pipermail/linux-pcmcia/2008-August/005787.html

Yes, that's PCMCIA infrastructure work.

> If you could send a more correct pattern,
> it's easy to change.

Well, there are mostly four areas, which, in my opinion, should be solved
like this:

sound/pcmcia/		should be under		SOUND
drivers/net/pcmcia/	should be under		NETWORK DEVICE DRIVERS
drivers/scsi/pcmcia/	should be under		SCSI SUBSYSTEM
and
drivers/char/pcmcia/cm4000_cs.c			OMNIKEY CARDMAN 4000 DRIVER
drivers/char/pcmcia/cm4040_cs.c			OMNIKEY CARDMAN 4040 DRIVER
and finally
drivers/char/pcmcia/ipwireess/*			IPWIRELESS DRIVER

Thanks!

	Dominik
