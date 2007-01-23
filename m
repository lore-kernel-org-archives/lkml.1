Return-Path: <linux-kernel-owner+w=401wt.eu-S932930AbXAWJpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbXAWJpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 04:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932931AbXAWJpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 04:45:15 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2165 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932930AbXAWJpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 04:45:14 -0500
Date: Tue, 23 Jan 2007 09:44:56 +0000
From: Pavel Machek <pavel@ucw.cz>
To: andi@lisas.de, davej@codemonkey.org.uk,
       kernel list <linux-kernel@vger.kernel.org>
Cc: seife@suse.de
Subject: i965 testers wanted (Re: intel-agp PM experiences)
Message-ID: <20070123094456.GG6033@ucw.cz>
References: <20070116135727.GA2831@elf.ucw.cz> <d120d5000701160608t73db4405n5d157db43899776a@mail.gmail.com> <20070116142432.GA6171@elf.ucw.cz> <d120d5000701161325h112a9299w944763b7f1032a61@mail.gmail.com> <20070117004012.GA11140@rhlx01.hs-esslingen.de> <20070117005755.GB6270@elf.ucw.cz> <20070118115105.GA28233@rhlx01.hs-esslingen.de> <20070118231650.GA5352@ucw.cz> <20070122044519.GA24398@zhen-devel.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070122044519.GA24398@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Whitelist? Let me blacklist it all the way to Timbuktu instead!
> > 
> > > I've been doing more testing, and X never managed to come back to working
> > > state without some of my couple intel-agp changes:
> > > - a proper suspend method, doing a proper pci_save_state()
> > >   or improved equivalent
> > > - a missing resume check for my i815 chipset
> > > - global cache flush in _configure
> > > - restoring AGP bridge PCI config space
> > 
> > Can you post a patch?
> 
> I've post a patch which trys to resolve pci config restore issue, see
> http://lkml.org/lkml/2007/1/16/297. It resolves s3 issue with my 965G machine,
> that my X can come back to live after s3, but I wasn't aware of the issues Andreas
> has noted. It'll be good if more people could try this out. 

Ok, I guess we'd like some testing here... so that in can be fixed in
mainline...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
