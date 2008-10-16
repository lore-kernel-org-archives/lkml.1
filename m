Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbYJPTbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbYJPTbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbYJPTbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:31:19 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:50855 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792AbYJPTbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:31:18 -0400
Date: Thu, 16 Oct 2008 21:31:13 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: bttv: video grabbing via v4l1 does not work since 2.6.25
Message-ID: <20081016193113.GA7015@darkside.22.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
References: <20080804111654.GA14074@darkside.22.kls.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20080804111654.GA14074@darkside.22.kls.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello again,

even though I doubt somebody cares, I tried to collect some more
information in the vague hope to get previously working features back,
maybe in two years or three...

On Mon, Aug 04, 2008 at 01:16:54PM +0200, Mario 'BitKoenig' Holbe wrote:
> with 2.6.25 bttv video grabbing via vlc stopped working.
> vlc is stable version 0.8.6.h which uses v4l(1) interface only.
> Up to 2.6.24 everything was working well.

With the release of vlc 0.9 I can confirm that grabbing over V4L2 works,
V4L, of course, is still broken.

> Please also note the changed vlc device recognition from "1 audios" to
> "0 audios" in .26.

The reason for this is probably that the volume control disappeared
(which was there and working in .24, of course). mute, balance, bass and
trebble controls are still there and working in .26 and to some extent
the driver seems to have some knowledge about a "volume" as well, as
v4l2-dbg --log-status shows. And some applications are somehow able to
set it to 0 from time to time - re-adjusting it is quite hard without
the volume control mentioned above.


Mario
--=20
Doing it right is no excuse for not meeting the schedule.
                                -- Plant Manager, Delphi Corporation

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUBSPeWgRS+e2HeSPbpAQKregf/UCYwCWtnDmgcrN/q4AvqQObZb08jMjQH
yl3JXFnW11At1r4aB76cmHcYRxQxbfKg6uoDwu7Nv7nrWRuAsaV9BWnPVrM//JD5
DnN7nUrF2hBxC8DQ4Nr60UfpqDN1pyLS87Xd2//3vpDF0Cq02/1A8IXHH8pgXjsk
1EG/kVDDgDU0gViMK2TTHbxWINs6yUwSIvYJ/MlGxsaa5R4Xll4nMpxjMi9IA56/
2slChSw2N4c3CeZWgtKKhnbOe6fAl6aIQ1wN3hzOSdebN67jfPo9QW7ON3EDyqpb
8ZzyFOABTbG9fah7Ls9LvJgZSf6iFaAxM5Xi3xByje1EATYP6UTVxg==
=IBQX
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
