Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbXGCQs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbXGCQs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759140AbXGCQqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:46:07 -0400
Received: from spock.bluecherry.net ([66.138.159.248]:3155 "EHLO
	spock.bluecherry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760132AbXGCQqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:46:03 -0400
Date: Tue, 3 Jul 2007 12:45:55 -0400
From: "Zephaniah E. Hull" <warp@aehallh.com>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Dmitry Torokhov <dtor@insightbb.com>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
Message-ID: <20070703164555.GA20370@aehallh.com>
Mail-Followup-To: Vojtech Pavlik <vojtech@suse.cz>,
	Dmitry Torokhov <dtor@insightbb.com>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070609084800.GR6362@aehallh.com> <200706120120.00494.dtor@insightbb.com> <20070612052316.GX6362@aehallh.com> <200706120135.06428.dtor@insightbb.com> <20070612054031.GY6362@aehallh.com> <20070702152044.GA24665@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20070702152044.GA24665@suse.cz>
X-Notice-1: Unsolicited Commercial Email (Aka SPAM) to ANY systems under
X-Notice-2: our control constitutes a $US500 Administrative Fee, payable
X-Notice-3: immediately.  By sending us mail, you hereby acknowledge that
X-Notice-4: policy and agree to the fee.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 02, 2007 at 05:20:44PM +0200, Vojtech Pavlik wrote:
> On Tue, Jun 12, 2007 at 01:40:31AM -0400, Zephaniah E. Hull wrote:
> > On Tue, Jun 12, 2007 at 01:35:05AM -0400, Dmitry Torokhov wrote:
> > > On Tuesday 12 June 2007 01:23, Zephaniah E. Hull wrote:
> > > > On Tue, Jun 12, 2007 at 01:19:59AM -0400, Dmitry Torokhov wrote:
> > > > > 
> > > > > Like I said I would love if xf86-input-evdev did not grab the
> > > > > device at all.
> > > > 
> > > > We have to disable the legacy input handlers somehow, not doing so
> > > > simply isn't an option.
> > > 
> > > I do not follow. If user's xorg.conf does not use /dev/input/mice and
> > > does not use "kbd" driver then grabbing is not required, is it? Now,
> > > as far as I understand, lack of hotplug support in X is the main
> > > obstacle for removing "mouse" and "kbd" drivers, correct?
> > 
> > Sadly, not quite.
> > 
> > The problem is that if the user is not using the mouse and kbd drivers
> > at all, but is instead using xf86-input-evdev, and no grabbing is done,
> > then all key presses end up going to the console.
> 
> X still switches to its own VT, so those keys go to the X server via the
> console, and GPM also knows about console switching ...
> 
> That is a sane way how to prevent the regular console from getting
> keypresses/mouse movements.

Not really, what happens when the user presses alt-F1?  A way to tell
the kernel that events from a given input device should not go to the
console has been needed since the very first time an X driver allowed
keyboard events from /dev/input/event<n>, and that still has not
changed.

We just want a more flexible approach then what we are already using[0].

I'll see about writing something up when I get back to my computers[1]
and have things set back up[2].

Zephaniah E. Hull.

0: EVIOCGRAB.
1: The night of the 10th.
2: It could be a few days after I get back.

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGin1DRFMAi+ZaeAERAnPqAKDUhMRhvdaUx5NfJq5YvItvW2wbRwCfQhW1
/HumpiswhnnG2/Ju3+29Dtc=
=FzM3
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
