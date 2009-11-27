Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbZK0Gus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbZK0Gus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 01:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZK0Gur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 01:50:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49253 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZK0Guq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 01:50:46 -0500
Date: Fri, 27 Nov 2009 17:50:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>, alsa-devel@alsa-project.org,
       tj@kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       tiwai@suse.de
Subject: Re: [PATCH] ASoC: tlv320dac33: Change RT wq to singlethread wq
Message-Id: <20091127175046.ee37c8f6.sfr@canb.auug.org.au>
In-Reply-To: <20091126154746.GA10674@rakim.wolfsonmicro.main>
References: <1259236511-25805-1-git-send-email-peter.ujfalusi@nokia.com>
	<20091126154746.GA10674@rakim.wolfsonmicro.main>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Nov_2009_17_50_46_+1100_JOagmm34_4TSLs4I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Nov_2009_17_50_46_+1100_JOagmm34_4TSLs4I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Nov 2009 15:47:46 +0000 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> On Thu, Nov 26, 2009 at 01:55:11PM +0200, Peter Ujfalusi wrote:
> > RT workqueue is going away in the near future, replace it with
> > singlethread wq for now, which is still supported.
> >=20
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
>=20
> Applied, thanks.

I also put this patch in linux-next (after the sound tree merge) for
today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_Nov_2009_17_50_46_+1100_JOagmm34_4TSLs4I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksPdsYACgkQjjKRsyhoI8xSMwCeP0VrFTOt1+nhBg1atgarZD/S
AuEAn0yWIoDegzPTRqjczwcp5EqHnV0a
=u6ZS
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Nov_2009_17_50_46_+1100_JOagmm34_4TSLs4I--
