Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbYBLWaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbYBLWaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:30:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYBLW3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:29:43 -0500
Received: from wren.kitenet.net ([80.68.85.49]:47895 "EHLO kitenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbYBLW3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:29:41 -0500
Date: Tue, 12 Feb 2008 17:29:37 -0500
From: Joey Hess <joeyh@debian.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: maximilian attems <max@stro.at>, 464962@bugs.debian.org,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Bug#464962: immediate crash on boot on TM5800
Message-ID: <20080212222937.GA30827@kodama.kitenet.net>
References: <20080210031849.GA3370@dragon.kitenet.net> <20080210110659.GB8574@stro.at> <20080210192139.GA17647@kodama.kitenet.net> <20080212160522.GB5221@stro.at> <20080212195254.GA6252@kodama.kitenet.net> <20080212201048.GD22054@baikonur.stro.at> <47B2025B.1030103@zytor.com> <20080212210244.GF22054@baikonur.stro.at> <47B20C1C.5020208@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <47B20C1C.5020208@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

H. Peter Anvin wrote:
> maximilian attems wrote:
>> On Tue, Feb 12, 2008 at 12:32:27PM -0800, H. Peter Anvin wrote:
>>> INT 6 is #UD, undefined instruction.
>>>
>>> If you could send me a copy of your vmlinux file (not bzImage), it=20
>>> would speed things up.
>>
>> cp -l src/linux-2.6-2.6.24/debian/build/build_i386_none_686/vmlinux ~/pu=
blic_html/
>>
>> http://charm.itp.tuwien.ac.at/~mattems/
>> =20
>
> Are you sure that build matches the bug report?
>
> The EIP given falls inside the .data segment of that kernel, =20
> specifically inside the symbol init_task.

The stack trace I copied down originally was for a 2.6.24 kernel. I can
copy down the one .25-pre if that'd be useful, but it sounds like you're
reproduced it on your own.

(I'm raising the priority of this bug report since it sounds like it
affects more than just my hardware.)

--=20
see shy jo

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsh3Rd8HHehbQuO8RAtfVAJ9f2byskIZbamkoy95/l9UlK7ZjFwCfT/fh
Es2vQCMZgtRgJ92jbN0SPww=
=oADc
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
