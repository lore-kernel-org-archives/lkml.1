Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab0CDRoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:44:10 -0500
Received: from systemlinux.org ([83.151.29.59]:33051 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0CDRoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:44:08 -0500
Date: Thu, 4 Mar 2010 18:42:39 +0100
From: Andre Noll <maan@systemlinux.org>
To: John Hughes <john@Calva.COM>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 15426] New: Running many copies of bonnie++ on different filesystems seems to deadlock in sync
Message-ID: <20100304174239.GO7517@skl-net.de>
References: <bug-15426-10286@http.bugzilla.kernel.org/> <20100302161627.bf02d0a2.akpm@linux-foundation.org> <4B8E517E.3010702@Calva.COM> <20100303115015.GN5768@kernel.dk> <4B8E5805.30505@Calva.COM> <20100303120317.GP5768@kernel.dk> <20100303144241.GF21495@skl-net.de> <4B8FC9F8.1050700@Calva.COM>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7H0CdmT9ysYyfjsg"
Content-Disposition: inline
In-Reply-To: <4B8FC9F8.1050700@Calva.COM>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7H0CdmT9ysYyfjsg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15:55, John Hughes wrote:
> >That's the same patch you posted two weeks ago and on which Linus
> >commented he thinks it is broken. He also proposed another, simpler
> >patch (included below) which I'm running for a few days and which
> >fixes the sync problem for me.
> > =20
> I've tried the "simpler patch" on my system and it makes no difference=20
> for me.

Does it make no difference to Jens' patch, or no difference to an
unpatched kernel?

BTW, switching from cfq to noop or deadline also improved things a
bit for me.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--7H0CdmT9ysYyfjsg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLj/EPWto1QDEAkw8RAsuYAJ90DrELgiEC9xLiNc8I2V8WBMTXegCgnedV
NHyjFQevYQmtnBSqdJwQhuo=
=7cl2
-----END PGP SIGNATURE-----

--7H0CdmT9ysYyfjsg--
