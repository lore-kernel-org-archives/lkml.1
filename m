Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZBDKCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZBDKCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZBDKBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:01:54 -0500
Received: from diva.malsain.org ([91.121.19.57]:37482 "EHLO diva.malsain.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZBDKBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:01:53 -0500
X-Greylist: delayed 2729 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Feb 2009 05:01:53 EST
Subject: Re: cgroup mount point
From: Josselin Mouette <joss@debian.org>
To: debian-devel@lists.debian.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090204003847.308cd0df@sbs173>
References: <20090202200013.GU3643@vespa.holoscopio.com>
	 <1233606371.15779.32.camel@radis.liafa.jussieu.fr>
	 <20090202205246.GA28593@glandium.org>
	 <20090202214153.GV3643@vespa.holoscopio.com>
	 <20090203102416.GA8886@redhat.com> <87ljsnzo4v.fsf@benfinney.id.au>
	 <1233671913.8902.53.camel@abacate.horta>
	 <6599ad830902030855h1753f4a4o3a303b4dbddf10de@mail.gmail.com>
	 <20090203184915.GA10004@glandium.org>
	 <20090203185117.GB3359@mini-me.seanius.net>
	 <6599ad830902031114t7de1b570p4ed5ec497e2e150e@mail.gmail.com>
	 <20090204003847.308cd0df@sbs173>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IxhQGec//Iwh5eUNeTg1"
Date: Wed, 04 Feb 2009 10:16:21 +0100
Message-Id: <1233738981.4045.4.camel@shizuru>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IxhQGec//Iwh5eUNeTg1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le mercredi 04 f=C3=A9vrier 2009 =C3=A0 00:38 +0100, Harald Braumann a =C3=
=A9crit :
> So, what's the problem with /dev/cgroups then? If shm/ and pts/
> are allowed under /dev, wouldn't it be discriminating against
> cgroups/, to not allow it there?

/dev/pts contains device entries, so it sounds right to put it in /dev.
Similarly if the cgroups FS provides facilities to control some system
settings, it clearly belongs in /sys.

(/dev/shm is another story, and if you asked me, I=E2=80=99d have put it
in /lib/shm instead, but it=E2=80=99s a bit late to change it.)

--=20
 .''`.
: :' :      We are debian.org. Lower your prices, surrender your code.
`. `'       We will add your hardware and software distinctiveness to
  `-        our own. Resistance is futile.

--=-IxhQGec//Iwh5eUNeTg1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJiVzkrSla4ddfhTMRAuIvAJ97+myCtPh+C0ggOUYbYbjtI3uprQCcC1OB
FrLuEEAmuRmriX6+cDTqUPs=
=QrjL
-----END PGP SIGNATURE-----

--=-IxhQGec//Iwh5eUNeTg1--

