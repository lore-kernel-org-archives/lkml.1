Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbXFDFWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbXFDFWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 01:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbXFDFWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 01:22:23 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:40231 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbXFDFWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 01:22:22 -0400
Subject: Re: A kexec approach to hibernation
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: vgoyal@in.ibm.com
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20070604044041.GB10206@in.ibm.com>
References: <878xb3l888.fsf@jbms.ath.cx> <200706012339.06379.rjw@sisk.pl>
	 <87zm3j9usv.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl>
	 <87odjz9qo9.fsf@jbms.ath.cx>  <20070604044041.GB10206@in.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qDlbX9bzJsBAGRUwdseW"
Date: Mon, 04 Jun 2007 15:22:20 +1000
Message-Id: <1180934540.1169.31.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qDlbX9bzJsBAGRUwdseW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

I can see that the idea of writing a kernel image from using another
kernel sounds nice and clean initially, but the more we get into the
details (yes, I am listening, even though I said nothing before now),
the more it's sounding like the cure is worse than the disease.

To get rid of process freezing, we're talking about:
* making hibernation depend on depriving the user of 32 or 64M of
otherwise perfectly usable memory (thereby making hibernation on
machines with less memory impossible)
* requiring them to set up kexec or kdump (I don't understand the
difference, sorry) or some new variation
* adding interfaces to tell kexec/dump/whatever what pages need to be
saved and reloaded
* adding convolutions in which at resume time we boot one kernel, switch
to another kernel to do the loading and then switch back again to the
resumed kernel (assuming I understand what you're suggesting).

It all sounds terribly complicated and confusing to me, and that's
before I even begin to think about how this second kernel could possibly
write the image to an encrypted device or LVM or such like that the
first kernel knows about and might use now.

Can't we just get the freezer right and be done with it?

Regards,

Nigel

--=-qDlbX9bzJsBAGRUwdseW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGY6GMN0y+n1M3mo0RAvWtAKCzU0OD+ZS0NTGYMwBOnNYFd8lSuQCgiWi2
uhBXxQKkSwQUjUhHnw26TpA=
=s9jv
-----END PGP SIGNATURE-----

--=-qDlbX9bzJsBAGRUwdseW--

