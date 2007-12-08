Return-Path: <linux-kernel-owner+w=401wt.eu-S1751888AbXLHRsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbXLHRsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbXLHRsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:48:13 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:37079 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbXLHRsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:48:12 -0500
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
From: Jon Masters <jonathan@jonmasters.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Theodore Tso <tytso@mit.edu>, Mike McGrath <mmcgrath@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20071208174343.GK19691@waste.org>
References: <20071204204036.484f11ac@the-village.bc.nu>
	 <20071204210827.GE19691@waste.org> <4755C423.60907@redhat.com>
	 <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com>
	 <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com>
	 <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion>
	 <20071208173204.GI17037@thunk.org>  <20071208174343.GK19691@waste.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sat, 08 Dec 2007 12:47:15 -0500
Message-Id: <1197136035.6899.16.camel@perihelion>
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


On Sat, 2007-12-08 at 11:43 -0600, Matt Mackall wrote:
> On Sat, Dec 08, 2007 at 12:32:04PM -0500, Theodore Tso wrote:
> > On Sat, Dec 08, 2007 at 02:37:57AM -0500, Jon Masters wrote:
> > > > BTW, You may be better off using "uuidgen -t" to generate the UUID in
> > > > the smolt RPM, since that will use 12 bits of randomness from
> > > > /dev/random, plus the MAC, address and timestamp.  So even if there is
> > > > zero randomness in /dev/random, and the time is January 1, 1970, at
> > > > least the MAC will contribute some uniqueness to the UUID.
> > > 
> > > I haven't checked how uuidgen uses the MAC, but I would suggest that
> > > that is not something Fedora should jump at doing - although it would
> > > help ensure unique UUIDs, it also contributes to the tinfoil hat
> > > responses that usually come up with things like smolt.
> > 
> > Huh?  What's the concern?  All you are submitting is a list of
> > hardware devices in your system.  That's hardly anything sensitive....
> 
> Using MAC addresses -does- de-anonymize things though and presumably
> anonymous collection is a stated goal.

Right. And the more I think about it, the more I think the solution is
going to be for the smolt server to generate the UUID and tell the
client about it. Anything else seems to be based on hope, especially
when you're installing via kickstart or similar type of process.

Jon.


