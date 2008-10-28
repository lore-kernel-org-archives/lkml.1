Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYJ1SiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYJ1SiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYJ1Sh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:37:58 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:56151 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYJ1Sh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:37:57 -0400
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Mirco Tischler <mt-ml@gmx.de>
Cc: Zhu Yi <yi.zhu@intel.com>, Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W.Linville" <linville@tuxdriver.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>
In-Reply-To: <20081028172418.3c8e91f1@mtlp.12.dimension> (sfid-20081028_172505_344390_B01D226B)
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
	 <1225157618.2917.215.camel@debian.sh.intel.com>
	 <20081027213217.53558319@infradead.org>
	 <1225171414.2917.229.camel@debian.sh.intel.com>
	 <20081028172418.3c8e91f1@mtlp.12.dimension>
	 (sfid-20081028_172505_344390_B01D226B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aUi0c4MsSnVdpn0b7GFr"
Date: Tue, 28 Oct 2008 19:36:34 +0100
Message-Id: <1225218994.3598.41.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aUi0c4MsSnVdpn0b7GFr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-28 at 17:24 +0100, Mirco Tischler wrote:

> > This is a different bug. He has the wireless worked sometimes.
> >=20
> > I think your problem relates to 5GHz channel usage. We have already a
> > patch queued to resolve the problem. We will have regulatory framework
> > reworked to better solve the problem. But I guess it will be in .29 tim=
e
> > frame.
> >=20
> > Thanks,
> > -yi
> I tested Arjan's solution nevertheless and it seems to do the job. I can'=
t find
> the "TX Power requested" line anymore on dmesg output with that config op=
tion
> enabled anymore and it connects without problems.

Can we have a dmesg output with the "TX power requested" line posted
here?

johannes

--=-aUi0c4MsSnVdpn0b7GFr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJB1uvAAoJEKVg1VMiehFY6ZwP/RHbu4/+BODKzryx9FYmvcW8
5Mo/3uFmFYbcvRJ1nr+GVnTcK93dGkJSnFh3lx6e6blcZvJEij3YHcetZmByM4+p
tbVX4KyqmxTmYB0h0gWX5uWp834tT9M1eOJgrVEHH00OM+zo8Cco43VqrAoipTN2
Nw1VYljVWOwUSiSAExCyocxAVACE78tAlVqG1B6i+gPxyGKX9ckgmjuNypkFUHH5
nMPAHREznHwdhFoG2tRKxpmAGL19vjhJx2iulLlooX1IJ25CwrL1ajvgW+TCbY7y
yb4xF7cki8MdeQSIjKFPfFiR0UEwzFESpZk6qunTyVLHML08ZLto2SZrkOy2eXop
u4xKXq3dbypHneUHcASJ7ohX7DcL+X+I1StXHaawYfQTncyuEjDTSSLd9cEgTDiy
7SEiUxIskwmTu8fxuIKUePrttFP+1bTuHsXba+K20uJ0IEufMLRd3W0bT1l+i5IW
du9wmM4bsyYt+ac8sABpvQ26DO+NdlhqXReeMV+dCDvkBOw7IAHKoSeFXpGwSglf
JQgI/Ht6PrcwhdpTK1FVQ+qcZegD3kcDRHP1pxePDq/AgO9as3jLxJqUzE4Rey7d
uuSRXMH1vTg17/ueg8fRxloRAg6bMnQupTS7xrGdKZA0wgNJckcc/yRVw5/dw+SE
BUt/D+jnaj6DCjIA5D1U
=CMEv
-----END PGP SIGNATURE-----

--=-aUi0c4MsSnVdpn0b7GFr--

