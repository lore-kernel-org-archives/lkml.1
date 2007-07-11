Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbXGKRwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbXGKRwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759959AbXGKRvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:51:55 -0400
Received: from mercury.sygneca.com ([83.142.230.29]:47802 "EHLO
	mx2.sygneca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759414AbXGKRvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:51:54 -0400
Message-ID: <46951892.20406@martinorr.name>
Date: Wed, 11 Jul 2007 18:51:14 +0100
From: Martin Orr <martin@martinorr.name>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070621)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_tiberius-6120-1184176306-0001-2"
To: Andi Kleen <andi@firstfloor.org>
CC: Stefano Rivoir <s.rivoir@gts.it>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>	<4693327E.6000006@gts.it>	<alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org>	<46947ADF.4080605@gts.it> <p73vecrxf0t.fsf@bingen.suse.de>
In-Reply-To: <p73vecrxf0t.fsf@bingen.suse.de>
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_tiberius-6120-1184176306-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable

O#n 11/07/07 14:10, Andi Kleen wrote:
> Stefano Rivoir <s.rivoir@gts.it> writes:
>> Linus Torvalds wrote:
>>> On Tue, 10 Jul 2007, Stefano Rivoir wrote:
>> Ok, the guilty bit is gcc: in my box, compiling kernel with gcc 4.2.x
>> (which is installed on my debian/sid) turns into a hang (in init,
>> seemingly, maybe not even in kernel itself), while gcc-4.1 is allright=
=2E
>=20
> The standard way to track this down is to compile different directories=

> of the kernel with different gcc versions. Then when you find the direc=
tory
> go down to files. Then you could eventually go down to functions, altho=
ugh
> that tends to involve quite some editing work. But already knowing
> the file would be useful.

I have done this.  The file is arch/x86_64/kernel/signal.c: if I compile
this with gcc 20070627 then everything works, if I compile it with gcc
20070707 then udevsettle hangs.  This is independent of the gcc version u=
sed
to compile the rest of the kernel.  (The dates refer to versions of the
Debian gcc-4.2 package and its dependencies.)


--=20
Martin Orr


--=_tiberius-6120-1184176306-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGlRijZ6a/BjxtAMARAp9VAJ9e8jy1uiK8Re69sKG0BGr9eZIWBgCg+LoE
ARaZj/Vs/SUulNR4JYu7b5A=
=dBFe
-----END PGP SIGNATURE-----

--=_tiberius-6120-1184176306-0001-2--
