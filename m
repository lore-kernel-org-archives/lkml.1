Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbZJZHoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbZJZHoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZJZHoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:44:18 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:55234 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbZJZHoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:44:17 -0400
Subject: Re: [PATCH] net: Adjust softirq raising in __napi_schedule
From: Johannes Berg <johannes@sipsolutions.net>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Tilman Schmidt <tilman@imap.cc>, David Miller <davem@davemloft.net>,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless@vger.kernel.org,
       linux-ppp@vger.kernel.org, netdev@vger.kernel.org, paulus@samba.org,
       Michael Buesch <mb@bu3sch.de>, Oliver Hartkopp <oliver@hartkopp.net>
In-Reply-To: <20091026074126.GA6187@ff.dom.local>
References: <4AD31213.6020006@imap.cc> <20091015114052.GA9870@ff.dom.local>
	 <4AD76184.6030900@gmail.com> <4ADF5710.4030505@imap.cc>
	 <20091021211906.GA11401@ami.dom.local>
	 <1256160330.12174.2.camel@johannes.local>
	 <20091021213947.GA12202@ami.dom.local>
	 <1256200021.12174.11.camel@johannes.local> <4AE1C00B.5010008@imap.cc>
	 <1256309191.12174.51.camel@johannes.local>
	 <20091026074126.GA6187@ff.dom.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-E+8aKjCJrS4WO5H9zABR"
Date: Mon, 26 Oct 2009 08:44:14 +0100
Message-ID: <1256543054.28230.6.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E+8aKjCJrS4WO5H9zABR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-26 at 07:41 +0000, Jarek Poplawski wrote:

> > netif_rx_ni() disables preemption.
>=20
> You wrote earlier:
>=20
> > [...] the networking layer needs to have
> > packets handed to it with softirqs disabled.
>=20
> How disabling preemption can fix something which needs softirqs
> disabled? Could you be more precise?

No, I wrote that I didn't know. I suppose now that I looked at it I do
know, and only disabling preemption is required.

johannes

--=-E+8aKjCJrS4WO5H9zABR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK5VNLAAoJEODzc/N7+QmaAZoP/j9hMJgijXD++p4xhyWTy+GX
rFtthdxV0HfkilIABL2+ckwdscqaLsb7llJ7KRQrmGcIr//3pW3CUcSfsEVorvzR
sOQE4mnQFR/MjpH+xKywUIZ99yS8ys8Ks/QeFOU5gQ3LrWF+xIVZf9jSXPR72GZg
1fDCMbjmYn6NTuAdn9HC5go/WKRxhSn8OZe7NX8HsxCVqPlzIzgo0lrjVsH51FyR
QNHdDT5qHZ6nADVolTC04v7VELo3cGPcrMr7GJnkwk8abfpNDR4rindKceF/yft0
SSfgKVuAIicUS6/SwT4ktUdTe0kuZDE2keDJaK2zDJZUZNMOiI/NoShhNMv6lSBi
CBx/o2lM7VoClPmMhjcf8feR3SHnqpgsZimDhmPBMxL7BSx+uIfLPfdp1WtHkzCl
Vlxk1Nfr77G5RMspB6t68fRMzX80Xyh0Ok58opD/ToVtL9AvG3U8n998jwIM4sa7
y8MpeiIIKOm0cm7r6s7iEaSTb92P3ZW+C28a6BWnm5Yxqy/SO4rhCmoYqNav16W4
XuoZqa2WAEEV4pLM1oqPBRzRVN+dYzEOF9POS7eP3OQonxHKStjKldJRFMCAcX51
58zZ+/FRlPOQP69xZYlpsYo9c66dZCgnbd9d23atBDxzEDLJjXimttWYRn0x+aZi
tUbG6z5uXopGiNEU188C
=FWoo
-----END PGP SIGNATURE-----

--=-E+8aKjCJrS4WO5H9zABR--

