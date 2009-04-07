Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbZDGM54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbZDGM54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZDGM5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:57:46 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbZDGM5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:57:46 -0400
Subject: Re: [Bug #12490] ath5k related kernel panic in 2.6.29-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Sergey S. Kostyliov" <rathamahata@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <20090407024021.GA26739@hash.localnet>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <AsKNxFx2juN.A.GaD.UJn2JB@chimera>  <20090407024021.GA26739@hash.localnet>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NAspTYPuwUZSALabFrcQ"
Date: Tue, 07 Apr 2009 12:03:45 +0200
Message-Id: <1239098625.22453.6.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NAspTYPuwUZSALabFrcQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Anyway here's a patch to buy some time.  Johannes, would this be
> an acceptable band-aid for now?

This is going to make it print two warnings for one occurrence of the
problem though. I'd much prefer to put something into minstrel.c to
catch when _it_ returns bogus values and in that case return 0, that way
at least the bandaid is restricted to the code it patches up.

johannes

--=-NAspTYPuwUZSALabFrcQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ2yT9AAoJEKVg1VMiehFY5ssP/1zraHx9D+zArFf/moysn0O1
51DyEyqrIFxwFPev84O8oeaxbTM9G0esn4lMqqPxy+iyk3LFTXxxb/F+c7BizkKd
iB6EoKq09Ddb9m7D0brpcUE96VYa6B3/paHrxGx8Wi3aVt44+R0klcAQoeOShTcV
rpalvQG3gkONOhjyRoRc1rMudcR1xE1EFb+EA35hrbPIZj5x7ejwv6QtZ9Bg8H9K
crLElJktnPgiyrWorjK1tBYjs9lICrtzdXFaRGVIKN14Xgzo63AoAIa9qjGqofta
Mo5f8wsEaEPCOcQqYYStIsk6rECRSt6Vg/WpYTBJ99WwqP4sz14zDOjofs6WZvbg
m/m8AJJNg4mytBFREHZaU4V+Fs7KZUXSfzlfPa2yyWmCP4eCccv5GC2RvKGWen9C
IHe2aWL5FLWj0sHPHS1BY1t+7mSNORKiORqwhrhLFLVU1MQmgm5Sk9WB5Kp0asC9
q6Jy7/hgJ58Pwd/snjRUCR/QpwsntdhZm8oUCrbrHR2nigHW8T0halXDuy4404Rt
QwreqZMmBNSvc9Btp0t9ruP1Q06viRGMeE6rWBw5n/QfcxlbKQPimwCNfnzunXTe
DBiz9Tp8nGNXKa+TrDOcSLQUoB/zZVQbUU+T7B6NdVNTgchjeDdMDpJOx1BaDnH+
7TrbVbjw1MJUaDCYecVB
=bz/D
-----END PGP SIGNATURE-----

--=-NAspTYPuwUZSALabFrcQ--

