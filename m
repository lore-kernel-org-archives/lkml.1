Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbXLHRzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbXLHRzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbXLHRzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:55:23 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:53524 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbXLHRzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:55:22 -0500
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
From: Jon Masters <jonathan@jonmasters.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Mike McGrath <mmcgrath@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20071208174908.GJ17037@thunk.org>
References: <20071204210827.GE19691@waste.org> <4755C423.60907@redhat.com>
	 <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com>
	 <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com>
	 <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion>
	 <20071208173204.GI17037@thunk.org> <475AD585.7020908@redhat.com>
	 <20071208174908.GJ17037@thunk.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sat, 08 Dec 2007 12:54:13 -0500
Message-Id: <1197136453.12636.1.camel@perihelion>
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


On Sat, 2007-12-08 at 12:49 -0500, Theodore Tso wrote:
> On Sat, Dec 08, 2007 at 11:33:57AM -0600, Mike McGrath wrote:
> >> Huh?  What's the concern?  All you are submitting is a list of
> >> hardware devices in your system.  That's hardly anything sensitive....
> >
> > We actually had a very vocal minority about all of that which ended up 
> > putting us in the unfortunate position of generating a random UUID instead 
> > of using a hardware UUID from hal :-/
> 
> Tinfoil hat responses indeed!  Ok, if those folks are really that
> crazy, my suggestion then would be to do a "ifconfig -a > /dev/random"
> before generating the UUID, and/or waiting until you just about to
> send the first profile, and/or if you don't yet have a UUID,
> generating it at that very moment.  The first will mix in the MAC
> address into the random pool, which will help guarantee uniqueness,
> and waiting until just before you send the result will mean it is much
> more likely that the random pool will have collected some entropy from
> user I/O, thus making the random UUID not only unique, but also
> unpredictable.

I do like that idea, and it could be combined with the DMI data for the
system containing things like asset tracking numbers, etc. Could use HAL
to generate a UUID based on hardware IDs and feed that in as entropy ;-)

Jon.


