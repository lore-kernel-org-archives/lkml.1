Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399AbXLHRqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbXLHRqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbXLHRqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:46:38 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:33968 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbXLHRqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:46:37 -0500
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
From: Jon Masters <jonathan@jonmasters.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Mike McGrath <mmcgrath@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20071208173204.GI17037@thunk.org>
References: <20071204195021.GB7259@thunk.org>
	 <20071204204036.484f11ac@the-village.bc.nu>
	 <20071204210827.GE19691@waste.org> <4755C423.60907@redhat.com>
	 <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com>
	 <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com>
	 <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion>
	 <20071208173204.GI17037@thunk.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sat, 08 Dec 2007 12:45:27 -0500
Message-Id: <1197135927.6899.13.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-08 at 12:32 -0500, Theodore Tso wrote:
> On Sat, Dec 08, 2007 at 02:37:57AM -0500, Jon Masters wrote:
> > > BTW, You may be better off using "uuidgen -t" to generate the UUID in
> > > the smolt RPM, since that will use 12 bits of randomness from
> > > /dev/random, plus the MAC, address and timestamp.  So even if there is
> > > zero randomness in /dev/random, and the time is January 1, 1970, at
> > > least the MAC will contribute some uniqueness to the UUID.
> > 
> > I haven't checked how uuidgen uses the MAC, but I would suggest that
> > that is not something Fedora should jump at doing - although it would
> > help ensure unique UUIDs, it also contributes to the tinfoil hat
> > responses that usually come up with things like smolt.
> 
> Huh?  What's the concern?  All you are submitting is a list of
> hardware devices in your system.  That's hardly anything sensitive....

Right, but the MAC is globally unique (well, that's normally true) so it
is an identifiable user characteristic, moreso than just a list of PCI
device IDs sitting on a particular bus. It's silly, but there it is.

Jon.


