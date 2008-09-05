Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbYIEUBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbYIEUBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 16:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbYIEUBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 16:01:38 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:41158 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYIEUBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 16:01:37 -0400
Subject: Re: [PATCH 1/2 v5] cfg80211: Add new wireless regulatory
	infrastructure
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1220643824-11398-1-git-send-email-lrodriguez@atheros.com>
References: <1220643824-11398-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dzoN3VCCPsUMlxidCWdd"
Date: Fri, 05 Sep 2008 22:01:32 +0200
Message-Id: <1220644892.11109.18.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dzoN3VCCPsUMlxidCWdd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-05 at 12:43 -0700, Luis R. Rodriguez wrote:
> This adds the new wireless regulatory infrastructure. The
> main motiviation behind this was to centralize regulatory
> code as each driver was implementing their own regulatory solution,
> and to replace the initial centralized code we have where:
>=20
> * only 3 regulatory domains are supported: US, JP and EU
> * regulatory domains can only be changed through a module parameter
> * all rules are built statically in the kernel
>=20
> We now have support for regulatory domains for many countries
> and regulatory domains are now queried through a userspace agent
> (CRDA) through udev allowing distributions to update regulatory rules
> without updating the kernel. Updates on regulatory rules can
> now be left as an independent effort.
>=20
> Each driver can regulatory_hint() a regulatory domain
> based on either their EEPROM mapped regulatory domain value to a
> respective ISO/IEC 3166-1 country code or pass an internally built
> regulatory domain. We also add support to let the user set the
> regulatory domain through userspace in case of faulty EEPROMs to
> further help compliance.
>=20
> Support for world roaming will be added soon for cards capable of
> this.
>=20
> For more information see:
>=20
> http://wireless.kernel.org/en/developers/Regulatory/CRDA
>=20
> For now we leave an option to enable the old module parameter,
> ieee80211_regdom, and to build the 3 old regdomains statically
> (US, JP and EU). This option is CONFIG_WIRELESS_OLD_REGULATORY.
> These old static definitions and the module parameter is being
> scheduled for removal for 2.6.29.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Looks fine to me now, as far as I've looked, I guess there'll be some
odd fixes required etc. but we can figure that out.

johannes

--=-dzoN3VCCPsUMlxidCWdd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwZAZAAoJEKVg1VMiehFYIkMP/3XN+1i3IGU1ugoJeIW+ypiK
ZeIlc9XQkpg2LqTzyFAw6gUXR3yAKXUkWARVc/7FYKXsUKBgBZGOW5LYa8TqA5E0
EIF3N+4V47sV+14Hyc3zEfp582Ogyq3rZIKFrNR7PaReWYA0KrSr5TVN96UomjB4
YlnYrzOT9Uq2LlZAusPpywqADSTH3PCh/thgsAXzf2uQPMfP+klvFccnBoeZLUlh
3Rl6nRI4Q1UhCPMpYt62pBzSstBREgE4YXu4dYOljZRe8i44mYfvTwSQz3xyPenz
dlU5h/tQ8ClLekVD9sTqptT6DrCZnqw+Ytk95m/PSpxa3dVpXatZG2VbkltzhjWR
B7t6BW4DSzNFl5xO3nuo5/06Sosg+kQ4v+XsBApmCke4sdwdHDaQRxMnzGFs2gyl
LZ6DuNiE9MlDf8x6naq2d5BfClJgHS3UJhmfHeheLKk32T/djKBf+43Hq6OrmE/0
UzybuMPoaP3Kx6raDkXAsHCvPTUkCk/g1oMGGuZ32+HGdgvdK2nb8zeMLFtgt9xy
oA8XcB993QAhRmyg4/kCrFFphj6dXSyDvQPjeZL054FWj5pyr8JhyjvnWYr+ep2o
VSLGf7spmzngsVi8VIY42imKBotPLvUZdNXsizjaVLsY/342+GN3HDEu4QxW7cKI
Ds+8Oc91Gw9KRBJ3h53n
=EI7k
-----END PGP SIGNATURE-----

--=-dzoN3VCCPsUMlxidCWdd--

