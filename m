Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbXLHSRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbXLHSRc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 13:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbXLHSR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 13:17:26 -0500
Received: from waste.org ([66.93.16.53]:39089 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbXLHSRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:17:25 -0500
Date: Sat, 8 Dec 2007 12:15:25 -0600
From: Matt Mackall <mpm@selenic.com>
To: Theodore Tso <tytso@mit.edu>, Mike McGrath <mmcgrath@redhat.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071208181525.GL19691@waste.org>
References: <4755C423.60907@redhat.com> <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com> <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion> <20071208173204.GI17037@thunk.org> <475AD585.7020908@redhat.com> <20071208174908.GJ17037@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208174908.GJ17037@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 12:49:08PM -0500, Theodore Tso wrote:
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

It might be better for us to just improve the pool initialization.
That'll improve the out of the box experience for everyone.

-- 
Mathematics is the supreme nostalgia of our time.
