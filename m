Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZCFQDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZCFQDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbZCFQCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:02:47 -0500
Received: from clegg.madduck.net ([193.242.105.96]:33757 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbZCFQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:02:46 -0500
Date: Fri, 6 Mar 2009 16:17:15 +0100
From: martin f krafft <madduck@debian.org>
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Future of md multipath
Message-ID: <20090306151715.GD6030@lapse.rw.madduck.net>
Mail-Followup-To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090303180433.GA27569@lst.de> <18863.15828.150450.275712@notabene.brown> <20090305130017.GA1696@piper.oerlikon.madduck.net> <18864.46425.242906.213929@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="osDK9TLjxFScVI/L"
Content-Disposition: inline
In-Reply-To: <18864.46425.242906.213929@notabene.brown>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux squeeze/sid kernel 2.6.29-rc7-686 i686
Organization: The Debian project
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--osDK9TLjxFScVI/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Neil Brown <neilb@suse.de> [2009.03.06.0632 +0100]:
> > I understand that dm-multipath is more favourable, but unless
> > there's a riskless way to convert mdadm multipath into dm-multipath
> > on old systems, I don't think we have the option of deprecating it,
> > unless deprecation lasts for several years.
>=20
> Always the practical one, aren't you :-)

Goes with the territory. Debian does not need to make long term
support guarantees. They're inherent in our quality assurance,
security support, and chaotic organisation. :)

> I wonder how hard it would be to get mdadm to assemble a multipath
> using the 'dm' code rather than the 'md' code....
> Or to get the md layer in the kernel to hook in to the dm multipath
> implementation.

A migration isn't possible?

> I think it is probably worth putting in a printk now to say "You
> should probably be using dm-multipath".  But we probably do need
> to leave the code there for a while longer..

Maybe it would be possible to disable creation of new multipath
arrays, but still to support existing ones, insert the warning, and
quote a fixed deprecation date, say, 5 years into the future?

--=20
 .''`.   martin f. krafft <madduck@d.o>      Related projects:
: :'  :  proud Debian developer               http://debiansystem.info
`. `'`   http://people.debian.org/~madduck    http://vcs-pkg.org
  `-  Debian - when you have better things to do than fixing systems
=20
god is dead.
    -- nietzsche
nietzsche is dead.
    -- god
nietzsche is god.
    -- dead

--osDK9TLjxFScVI/L
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmxPnsACgkQIgvIgzMMSnUQcQCff50ZnDoBq+g8Ek7c3O47GmPH
vKcAnRIu96ezlsqesT+c4i7mJOH8Sn5k
=F9q5
-----END PGP SIGNATURE-----

--osDK9TLjxFScVI/L--
