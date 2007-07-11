Return-Path: <linux-kernel-owner+w=401wt.eu-S1764266AbXGKMqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764266AbXGKMqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764076AbXGKMpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:45:50 -0400
Received: from mercury.sygneca.com ([83.142.230.29]:54206 "EHLO
	mx2.sygneca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764045AbXGKMpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:45:49 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2007 08:45:49 EDT
Message-ID: <4694CE86.4040209@martinorr.name>
Date: Wed, 11 Jul 2007 13:35:18 +0100
From: Martin Orr <martin@martinorr.name>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070621)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_tiberius-3605-1184157333-0001-2"
To: Stefano Rivoir <s.rivoir@gts.it>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>	<4693327E.6000006@gts.it>	<alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org>	<46947ADF.4080605@gts.it>
In-Reply-To: <46947ADF.4080605@gts.it>
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_tiberius-3605-1184157333-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable

On 11/07/07 06:38, Stefano Rivoir wrote:
> Linus Torvalds wrote:
> > On Tue, 10 Jul 2007, Stefano Rivoir wrote:
> >> 2.6.22 hangs at boot on my box. Here attached a original dmesg from =
2.6.21,
> >> and a copy of it where it stops on 2.6.22 (I can't attach the origin=
al 2.6.22
> >> dmesg because it's not logged to disk yet); it actually stops right =
after
> >> 'init' launches.
> Ok, the guilty bit is gcc: in my box, compiling kernel with gcc 4.2.x
> (which is installed on my debian/sid) turns into a hang (in init,
> seemingly, maybe not even in kernel itself), while gcc-4.1 is allright.=


I have the same problem, also on Debian sid on amd64.  I can report that =
the
Debian version 4.2-20070627-1 of gcc works, 4.2-20070707-1 does not.

Also the hang occurs in udevsettle; if you wait long enough (60 seconds?)=

then udevsettle times out and the boot continues (but doesn't get very fa=
r
with an almost empty /dev).

For a few more data points, I tried building my kernel with the new compi=
ler
and s/=3Dm/=3Dy/ on the .config and then disabling modules.  This didn't =
help.
I have also tried mixing modules and vmlinuz from different gcc versions;=

whether the hang occurs or not depends only on the version used to compil=
e
the vmlinuz.

--=20
Martin Orr


--=_tiberius-3605-1184157333-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGlM6QZ6a/BjxtAMARAo1fAKDGkBTsIvE83Ui/gh5qYZEY4JyN7gCg4kbM
tgyuvxzdEY6XArmnPAbjpOA=
=goiO
-----END PGP SIGNATURE-----

--=_tiberius-3605-1184157333-0001-2--
