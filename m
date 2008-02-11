Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbYBKQpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbYBKQpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYBKQpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:45:40 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:50975 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbYBKQpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:45:39 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH 1/2] SH/Dreamcast - joystick (Control pad)
Date: Mon, 11 Feb 2008 11:45:32 -0500
User-Agent: KMail/1.9.7
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Paul Mundt" <lethal@users.sourceforge.net>,
       "linux-sh" <linux-sh@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <1202684222.6237.9.camel@localhost.localdomain> <20080211112433.ZZRA012@mailhub.coreip.homeip.net> <23228.85.118.17.158.1202747372.squirrel@newgolddream.dyndns.info>
In-Reply-To: <23228.85.118.17.158.1202747372.squirrel@newgolddream.dyndns.info>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2296998.8IDTDY167H";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802111145.34150.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2296998.8IDTDY167H
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 11 February 2008, Adrian McMenamin wrote:
> On Mon, February 11, 2008 4:25 pm, Dmitry Torokhov wrote:
> > On Mon, Feb 11, 2008 at 11:19:22AM -0500, Mike Frysinger wrote:
> >> On Monday 11 February 2008, Adrian McMenamin wrote:
> >> > On Mon, February 11, 2008 12:22 am, Mike Frysinger wrote:
> >> > > no remove function ?  looks like the probe() forces a connect, but
> >> > > there's no remove() to force a disconnect ...
> >> >
> >> > Removing these devices (or any other plugged directly into the maple
> >> > ports) is a quick way to destroy your Dreamcast: hence they were nev=
er
> >> > implemented I guess. But there is no convincing reason for the
> >>
> >> software
> >>
> >> > not doing so, I suppose. I can just put in comments about it.
> >>
> >> and not allow the driver to be built as a module until the comments
> >> become code ...
> >
> > Normally drivers can be unbound from devices via sysfs even if they are
> > built-in, not modules.
>
> I meant comments about not being so silly as to start plugging maple
> devices in and out of the ports on the DC. I understand the point about
> the code and will rework appropriately.

is that a maple bus limitation or a joystick issue ?  if maple, then there=
=20
really isnt much holding back this driver ...

> All I wanted to do is take somebody's old code and get it to work on 2.6.
> But nothing is that simple :-/

better than nothing.  if someone doesnt like the lack of functionality, the=
y=20
know where the source is ;)
=2Dmike

--nextPart2296998.8IDTDY167H
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR7B7rkFjO5/oN/WBAQJMjhAAlxepu9dlh5aZUEDvPr5u6kh+OcSEvSYx
Nj3IDkX5CtYE8x3arDHtYqxwVoLgNmrcqsvvuPmwA3EuY8NXSJb/VBZzK2p89LVp
8hRBUzV4LZLFGRqpp/bggOpjZVngucWmVnAix+3vWpaZFm7JdQsKhfq3NZP7Ezxn
uTWEUdYojTgUUA0bqBSUBGFsUlE2bjPtVuQB9xCWVmyFW93jJPxm7mKh6fk0kvhd
bSUqD20QtbUBxuwht35zY3Bw+AACJa7nEd8dCzdGMLy1GBp1/N09J4ESJjO4Wb0w
OyIJZb9N1KEtrJ/QnZ6/LdeGhyq6dHsPrpna9X7AUNK2wfgNT27/lBrzsWz81doW
7rEB7+TeJIlf0+mREkV2bYd4xurUktfHfW+AezySKh7uBaFbD7ZBdrbKpkNVrpTe
VV9/c3nelMBH8RC87KBMb8IOEqKAhuNVa0XCXHLtQmqXGzrYfemvI3urR6r3B4mB
F4eXds6JQS1ZGOhUJS14afYYRQTd1Es2MWo/wgRIVlOePgvzGQtcJqq6YYSA7nyy
u8NCSnh6MOG/a28FZNR0oSJ+y54asm+qLuqUIFqDOBl1fF0JSKbYlwGVgsivx/Mq
vUKDvuRJs5UEkxodkRU2FE6KEJYpUBMUjs+7ObnqLJaDUqw59U1WNpRFgUZgbl3D
l0Aa9c8g8hU=
=Sv4A
-----END PGP SIGNATURE-----

--nextPart2296998.8IDTDY167H--
