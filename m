Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbYLNJW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbYLNJW4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 04:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYLNJWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 04:22:45 -0500
Received: from mout.perfora.net ([74.208.4.195]:52176 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbYLNJWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 04:22:44 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Dec 2008 04:22:44 EST
Date: Sun, 14 Dec 2008 03:16:59 -0600
From: Robby Workman <rw@rlworkman.net>
To: brian@interlinx.bc.ca
Cc: linux-kernel@vger.kernel.org
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
Message-ID: <20081214031659.4b700a2d@liberty.rlwhome.lan>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.12; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/VuFa74WwV5Fw3uLmZt2krss";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Provags-ID: V01U2FsdGVkX18tKBthbuRparz5/+ZuXHSKZyXHPCosDQQTLSC
 uDe2ykDh0udwdPAr1zvfryG8KFlqJ6Lz7G4b2CLKjDtQGlzd1o
 BIOJ57K5RLgy01uw2W7iw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VuFa74WwV5Fw3uLmZt2krss
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

In linux.kernel, Brian J. Murrell wrote:
> I'm trying to debug a resume problem on a compaq presario C700 laptop
> on the Ubuntu 2.6.24-22-generic kernel.
>
> SNIPPED
>
> These symptoms mirror a lot of other reports with this machine in that
> the first suspend/resume cycle works but a second attempts
> (apparently) suspends fine but fails on resume.  The backlight on the
> video does not come back and neither does the wireless connection, so
> I'm not positive the problems are purely video related.
>
> How can I proceed from here to further debug what kind of workarounds
> or solutions I might be able to use to get reliable suspend/resume
> functionality?


Assuming Ubuntu uses pm-utils for suspend/hibernate operations, then I
suspect you're needing this patch - the symptoms fit (suspend works
the first time, but fails thereafter), especially if a reboot causes
suspend to work fine again the first time...

http://cgit.freedesktop.org/pm-utils/commit/?id=3D6c9f2959a36e608e4d1f71230=
a9eaaa77940c54e

-RW

--Sig_/VuFa74WwV5Fw3uLmZt2krss
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklEzw8ACgkQvGy9tf6lsvu6dACfR0gHdpsdDlFq55zpIeoljcKz
QGsAnR2llqJJUtxdvyywX0vervIfPDjv
=5cZ2
-----END PGP SIGNATURE-----

--Sig_/VuFa74WwV5Fw3uLmZt2krss--
