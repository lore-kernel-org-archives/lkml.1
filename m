Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZALRIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZALRIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZALRIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:08:39 -0500
Received: from bsdimp.com ([199.45.160.85]:52748 "EHLO harmony.bsdimp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbZALRIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:08:38 -0500
Date: Mon, 12 Jan 2009 10:07:12 -0700 (MST)
Message-Id: <20090112.100712.107765266.imp@bsdimp.com>
To: pavel@suse.cz
Cc: linasvepstas@gmail.com, david@lang.hm, goodgerster@gmail.com,
       kyle@moffetthome.net, slashdot@jameshallam.info, davidn@davidnewall.com,
       linux-kernel@vger.kernel.org, hancockr@shaw.ca, ntpwg@lists.ntp.isc.org,
       pretzalz@techhouse.org, burdell@iruntheinter.net, nick@nick-andrew.net,
       jeff@kosowsky.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
From: "M. Warner Losh" <imp@bsdimp.com>
In-Reply-To: <20090112161115.GA1474@ucw.cz>
References: <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>
	<3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
	<20090112161115.GA1474@ucw.cz>
X-Mailer: Mew version 5.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message: <20090112161115.GA1474@ucw.cz>
            Pavel Machek <pavel@suse.cz> writes:
: On Mon 2009-01-05 11:42:35, Linas Vepstas wrote:
: > 2009/1/5  <david@lang.hm>:
: > > On Mon, 5 Jan 2009, Linas Vepstas wrote:
: > >
: > >>> Arguably the kernel's responsibility should be to keep track of the
: > >>> most fundamental representation of time possible for a machine (that's
: > >>> probably TAI) and it is a userspace responsibility to map from that
: > >>> value to other time standards including UTC,
: > >>
: > >> Yes, this really does seem like the right solution.
: > >>
: > >>> using control files
: > >>> which are updated as leap seconds are declared.
: > >>
: > >> Lets be clear on what "control files" means.  This does
: > >> *NOT* mean some config file shipped by some distro
: > >> for some package. That would be a horrid solution.
: > >> People don't install updates, patches, etc.  Distros
: > >> ship them late, or never, if the distro is old enough.
: > >>
: > >> A more appropriate solution would be to have
: > >> either the kernel or ntpd track the leap seconds
: > >> automatically.  First, the ntp protocol already provides
: > >> the needed notification of a leap second to anyone
: > >> who cares about it (i.e. there is no point in getting a
: > >> Linux distro involved in this -- a distribution mechanism
: > >> already exists, and works *better* than having a distro
: > >> do it).
: > >
: > > I disagree with this. NTP will only know about leap seconds if it was
: > > running and connected to a server that advertised the leap seconds during
: > > that month.
: > >
: > > for example, if you installed a new server today, how would it ever know
: > > that there was a leap second a couple of days ago?
: > 
: > OK, good point.  Unless your distro was less
: > than a few days old (unlikely), you are faced with the
: > same problem.  Sure, eventually, the distro will publish
: > an update (which will add to the existing list of 36 leap
: > seconds -- which is needed in any case, since no one
: > has a server that's been up since 1958),  but this is
: > unlikely to happen during this install window.
: > 
: > The long term solution would be write an RFC to extend
: > NTP to also provide TAI information -- e.g. to add a
: > message that indicates the current leap-second offset
: > between UTC and TAI.
: 
: Offset is not enough; you'd have to provide list of all previous leap
: seconds with 'when it happened' timestamps.

Well, today you can ftp the leapseconds.txt file from NIST.  Of
course, that assumes your machine is on the network, and not a dumb
slave of a smart head-end that's off the net...

Warner
