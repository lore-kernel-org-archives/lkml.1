Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZDVTht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZDVTht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbZDVThh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:37:37 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:35190 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZDVThg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:37:36 -0400
Date: Wed, 22 Apr 2009 16:37:29 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 fixed] e100: do not go D3 in shutdown unless system
	is powering off
Message-ID: <20090422193728.GI4691@vespa.holoscopio.com>
References: <1240237621-11415-1-git-send-email-cascardo@holoscopio.com> <200904202114.01932.rjw@sisk.pl> <20090421215248.GF6147@vespa.holoscopio.com> <200904220017.19670.rjw@sisk.pl> <20090422043828.GB3979@vespa.holoscopio.com> <9929d2390904212246n4817b25r4db653cd7e6a24c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B8ONY/mu/bqBak9m"
Content-Disposition: inline
In-Reply-To: <9929d2390904212246n4817b25r4db653cd7e6a24c1@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B8ONY/mu/bqBak9m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2009 at 10:46:19PM -0700, Jeff Kirsher wrote:
> On Tue, Apr 21, 2009 at 9:38 PM, Thadeu Lima de Souza Cascardo
> <cascardo@holoscopio.com> wrote:
> > After experimenting with kexec with the last merges after 2.6.29, I've
> > had some problems when probing e100. It would not read the eeprom. After
> > some bisects, I realized this has been like that since forever (at least
> > 2.6.18). The problem is that shutdown is doing the same thing that
> > suspend does and puts the device in D3 state. I couldn't find a way to
> > get the device back to a sane state in the probe function. So, based on
> > some similar patches from Rafael J. Wysocki for e1000, e1000e and ixgbe,
> > I wrote this one for e100.
> >
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > ---
>=20
> Thanks, I will add it to my queue of patches for e100.
>=20
> Also, just FYI, Auke is no longer a maintainer for
> e100/e1000/e1000e/igb/ixgb/ixgbe devices, so I have removed him from
> the thread.
>=20
> --=20
> Cheers,
> Jeff

Perhaps, Rafael should be mentioned in a Reviewed-by? As well as you if
you did review it? I guess a Tested-by and Reported-by me is overkill,
right? :-)

--B8ONY/mu/bqBak9m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknvcfgACgkQyTpryRcqtS3ANACfUvn/zTDz/Mk8MlleZZT1f948
zDMAnRimUtGoQLo9ueLJxJZAb/IXF/uG
=LUbo
-----END PGP SIGNATURE-----

--B8ONY/mu/bqBak9m--
