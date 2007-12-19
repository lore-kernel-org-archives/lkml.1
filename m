Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbXLSF4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbXLSF4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 00:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbXLSFz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 00:55:58 -0500
Received: from natgw.netstream.ch ([62.65.128.28]:50670 "EHLO
	denkbrett.schottelius.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751676AbXLSFz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 00:55:58 -0500
Date: Wed, 19 Dec 2007 06:55:50 +0100
From: Nico Schottelius <nico-kernel-20071219@schottelius.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Out of memory and no killable processes: 2.6.22-2-686-bigmem
Message-ID: <20071219055550.GE21042@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel-20071219@schottelius.org>,
	Robert Hancock <hancockr@shaw.ca>,
	LKML <linux-kernel@vger.kernel.org>
References: <fa.oSel00y9Hn5hvV3laxPiw9blEfU@ifi.uio.no> <4768692A.3030204@shaw.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nHwqXXcoX0o6fKCv"
Content-Disposition: inline
In-Reply-To: <4768692A.3030204@shaw.ca>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: denkbrett running Linux 2.6.23.11-denkbrett on i686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nHwqXXcoX0o6fKCv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Robert,

Robert Hancock [Tue, Dec 18, 2007 at 06:43:22PM -0600]:
> How much RAM is in these machines?

8 GiB

> If you're running tons of memory, it=20
> really is better to run a 64-bit kernel if possible.

Sure? Afaik that results in a bit slower access to memory and appart
=66rom being able to address MUCH more memory doesn't change the
situation.

Perhaps I missed something.

And updating to 64 Bit kernel also implies changing the userland, so
a reinstall would be necessary, wouldn't it?

> I believe there are=20
> some cases where low memory can be pretty easily exhausted on machines wi=
th=20
> lots of high memory.

Some minutes ago the third machine of that type freezed.
with 7 GiB of *free* memory, before getting oom+panic.

The thing that looks pretty the same is that the inode table / open
inodes shrinked very heavy from 41k to about 2k before the freeze
in about 3 days.

Same kernel, same Dell 1955 hardware, different machine.

Is it possible to debug this issue somehow?

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--nHwqXXcoX0o6fKCv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHaLJmuL75KpiFGIwRAsNcAJkB/CG26Of6Znu6zUdW33HKkv3J+QCgx9xY
Cv955TaOH8IvNjZp0g6mEAg=
=BPSw
-----END PGP SIGNATURE-----

--nHwqXXcoX0o6fKCv--
