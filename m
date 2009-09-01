Return-Path: <linux-kernel-owner+w=401wt.eu-S1751425AbZIAFp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbZIAFp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 01:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZIAFp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 01:45:56 -0400
Received: from clegg.madduck.net ([193.242.105.96]:38969 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZIAFpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 01:45:55 -0400
Date: Tue, 1 Sep 2009 07:45:07 +0200
From: martin f krafft <madduck@debian.org>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
       NeilBrown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
       Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Message-ID: <20090901054506.GA3323@piper.oerlikon.madduck.net>
Mail-Followup-To: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
	Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	NeilBrown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
	Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
References: <4A967175.5070700@redhat.com>
 <20090827221319.GA1601@ucw.cz>
 <4A9733C1.2070904@redhat.com>
 <20090828064449.GA27528@elf.ucw.cz>
 <20090828120854.GA8153@mit.edu>
 <20090830075135.GA1874@ucw.cz>
 <20090830152023.GB23828@mit.edu>
 <4807377b0908311049id9a2167r937bc8447c2b3546@mail.gmail.com>
 <20090831180746.GA32110@piper.oerlikon.madduck.net>
 <4807377b0908311526r3b42f581j27b9c26166b7ac96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <4807377b0908311526r3b42f581j27b9c26166b7ac96@mail.gmail.com>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux squeeze/sid kernel 2.6.31-rc3-amd64 x86_64
X-Subliminal-Message: debian/rules!
Organization: The Debian project
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Jesse Brandeburg <jesse.brandeburg@gmail.com> [2009.09.01.0026 =
+0200]:
> I misspoke w.r.t journalling, the idea I was trying to get across
> was to remount with -o sync while running on a degraded array, but
> given some of the other comments in this thread I'm not even sure
> that would help.  the idea was to make writes as safe as possible
> (at the cost of speed) when running on a degraded array, and to
> have the transition be as hands-free as possible, just have the
> kernel (or mdadm) by default remount.

I don't see how that is any more necessary with a degraded array
than it is when you have a fully working array. Sync just ensures
that the data are written and not cached, but that has absolutely
nothing to do with the underlying storage. Or am I failing to see
the link?

--=20
 .''`.   martin f. krafft <madduck@d.o>      Related projects:
: :'  :  proud Debian developer               http://debiansystem.info
`. `'`   http://people.debian.org/~madduck    http://vcs-pkg.org
  `-  Debian - when you have better things to do than fixing systems
=20
"how do you feel about women's rights?"
"i like either side of them."
                                                       -- groucho marx

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREDAAYFAkqctN8ACgkQIgvIgzMMSnX5JQCgquXMQpxCm/TTvmzoM5doIyPD
W5sAoNqXHt5sVywFP975Ka6hSBFXYHoS
=FJOm
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
