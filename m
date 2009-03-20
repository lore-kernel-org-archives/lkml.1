Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbZCTKVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbZCTKVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760902AbZCTKVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:21:13 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:58143 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761697AbZCTKVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:21:10 -0400
Date: Fri, 20 Mar 2009 11:21:07 +0100
From: Nico -telmich- Schottelius 
	<nico-linux-ipw3945-devel@schottelius.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Nico Schottelius <nico-linux-20090313@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net
Subject: Re: Strange reboots on 2.6.29-rc6-wl
Message-ID: <20090320102107.GA17975@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-ipw3945-devel@schottelius.org>,
	Sitsofe Wheeler <sitsofe@yahoo.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Nico Schottelius <nico-linux-20090313@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
References: <20090313200657.GA4907@denkbrett.schottelius.org> <20090313204100.GA3554@tuxdriver.com> <20090317075424.GD8777@denkbrett.schottelius.org> <20090317145753.GA1651@silver.sucs.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20090317145753.GA1651@silver.sucs.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc7-next-20090306-ikn x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Sitsofe Wheeler [Tue, Mar 17, 2009 at 02:57:53PM +0000]:
> On Tue, Mar 17, 2009 at 08:54:24AM +0100, Nico -telmich- Schottelius wrot=
e:
> >=20
> > Has anyone a clue on howto debug the build environment or
> > debugging the kernel before it's getting booted?
>=20
> If you have a serial console you can probably get output on that.

There's no native serial port on the machine :-/

> If you have flipped EMBEDDED to Y then you might also have to enable
> EARLY_PRINTK. Another trick might be to turn set
> BOOT_PRINTK_DELAY (Kernel hacking -> Delay each boot printk message by N
> milliseconds) to something like 2000 and see if you can read/catch the
> messages before the kernel reboots...

I've EARLY_PRINTK set, but other than the edd probing message
I don't see anything.

> Failing that start a git bisection (
> http://www.kernel.org/doc/local/git-quick.html#bisect or
> http://www.stardust.webpages.pl/files/handbook/handbook-en-0.3-rc1.pdf )
> from the last good kernel...

I really don't think that it's the kernel's fault, because _all_
new versions I compile instantly reboot.

Last one I tried was v2.6.29-rc8-241-g65c2449 (linux-2.6).
Isn't there some flag to enable step by step execution (like in gdb)?

Or is somebody else using Debian squeeze with latest updates?

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknDbhMACgkQuL75KpiFGIxregCaAq7Y4Tovp6B+V6TpZ5QhX4eM
CiIAoNlEcXIraUgXnl9fgceLj46Qiwd5
=DA/T
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
