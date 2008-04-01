Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbYDAL7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbYDAL7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbYDAL66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:58:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48047 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbYDAL65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:58:57 -0400
Date: Tue, 1 Apr 2008 12:52:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Soeren Sonnenburg <sonne@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini
	Core Duo
Message-ID: <20080401105213.GB10554@elf.ucw.cz>
References: <20080320060550.GA13200@dose.home.local> <20080320105432.GA13404@dose.home.local> <20080325231300.GA10641@thinkpad.home.local> <200803290003.16199.rjw@sisk.pl> <20080331212812.GB5313@dose.home.local> <1207030991.11035.35.camel@localhost> <20080401062734.GA8824@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401062734.GA8824@dose.home.local>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > [...]
> > > 
> > > > Can you please try to boot with acpi_new_pts_ordering and retest?
> > > 
> > > I just tried current -git (a9edadbf790d72adf6ebed476cb5caf7743e7e4a),
> > > without success. I still got the same hand at resume.
> > 
> > I am having the hang on resume problem too (macbook pro), cf.
> > http://bugzilla.kernel.org/show_bug.cgi?id=10319, 2.6.24 was fine.
> 
> What about 2.6.25-rc5? Up to this, resume works for me. -rc6 is broken.

Any chance to bisect?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
