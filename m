Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbYEEUvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbYEEUvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbYEEUvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:51:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:46576 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755700AbYEEUvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:51:21 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX18Wm3kKXRAWB6DCfsHrM7q9KbMJWe5nng6e5+02B1
	uJ0dd6PgS8BGap
Subject: Re: 2.6.26-rc1-git1 -- trying to get vblank count for disabled
	pipe 0
From: Mirco Tischler <mt-ml@gmx.de>
To: Steven J Newbury <steve@snewbury.org.uk>
Cc: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@tungstengraphics.com>,
       Miles Lane <miles.lane@gmail.com>, David Airlie <airlied@linux.ie>,
       DRI for Linux <dri-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1209991916.24777.8.camel@infinity>
References: <481E5EE6.6090503@gmail.com>
	 <1209975302.26326.263.camel@thor.sulgenrain.local>
	 <1209991916.24777.8.camel@infinity>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7PGWimYQE6W7GeNYp2xU"
Date: Mon, 05 May 2008 22:51:09 +0200
Message-Id: <1210020669.21903.16.camel@mtlp.tischlernetz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7PGWimYQE6W7GeNYp2xU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mo, 2008-05-05 at 13:51 +0100, Steven J Newbury wrote:
> Miles isn't alone, I also get 'trying to get vblank count for disabled
> pipe 0' (GM965).  vblank interrupts were previously not working for me,
> but they are now.  I'm not sure what's changed.=20
> >=20
> > Do you have any GL apps running when this happens?
> >=20
> For me, this happens every time a GL app is run.
>=20
> I'm also getting occasional lockups.  Often it's the window manager
> (metacity) that locks up when attempting to move a window, restarting
> the window manager unlocks X but attempting to move a window again
> results in another lockup.  When it's locked up the pointer moves and vt
> switching works but nothing else.  Other times I've had a hard lockup
> that required a hard reboot, this happens less frequently.
>=20
As written in a mail before, I have similar issues. I had the vblank
messages in 2.6.25-git17 or so, but they seem gone no. At that time, I
also had lockups, mostly when switching back from a vt to X. I was still
able to move the mouse, but the rest of the screen just didn't change
anymore. SSH login was still possible, so I tried to restart the X
server, but that did nothing. Although the X processes were finished, I
still had the X surface on my display, what seems rather strange to me.
By now situation has improved a bit, as the machine doesn't lockup
anymore. But from time to time I still get windows where only the outer
frame is shown, the contents of the window is transparent.
I have the impression that suspend/hibernation worsens the problems (no
proof though).
My graphics is a gm965 and I'm using gnome with the new compositing-able
metacity used in ubuntu 8.04.

--=-7PGWimYQE6W7GeNYp2xU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIH3M8z+diZ7c2xfgRAuVPAJ9ivf6bBAon2b94j659DGZTz7hLIgCeNLDr
buomfiE1dBrftgWdvmY8pug=
=m6Qt
-----END PGP SIGNATURE-----

--=-7PGWimYQE6W7GeNYp2xU--

