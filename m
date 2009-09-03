Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZICNeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZICNeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbZICNeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:34:31 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:54056 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbZICNea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:34:30 -0400
Subject: Re: Exporting kmemleak.h to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1251983939.22485.18.camel@pc1117.cambridge.arm.com>
References: <43e72e890909021729q7c40f907v7a81eaf5c8b73a61@mail.gmail.com>
	 <84144f020909022323na828156v4eb9a8497cadaef8@mail.gmail.com>
	 <1251983939.22485.18.camel@pc1117.cambridge.arm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lgssFZmV0Cq1a+PC1EVM"
Date: Thu, 03 Sep 2009 15:34:05 +0200
Message-Id: <1251984845.3336.25.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.91 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lgssFZmV0Cq1a+PC1EVM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-03 at 14:18 +0100, Catalin Marinas wrote:
> On Thu, 2009-09-03 at 09:23 +0300, Pekka Enberg wrote:
> > On Thu, Sep 3, 2009 at 3:29 AM, Luis R. Rodriguez<mcgrof@gmail.com> wro=
te:
> > > I was reviewing kmemleak code and noticed kmemleak.h went exported to
> > > userspace under include/linux/kmemleak.h. Do we expect userspace to
> > > use this stuff somehow? All relevant kmemleak structs are kept
> > > private, I'm curious what userspace apps would use this.
> >=20
> > AFAICT, nobody. Catalin, why is the header exported?
>=20
> I haven't done anything specifically to export it. It probably gets
> included via other files. Is adding #ifdef __KERNEL__ enough to avoid
> this problem?

It should be exported only if it's listed in Kbuild, which it isn't.
Luis?

johannes


--=-lgssFZmV0Cq1a+PC1EVM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKn8XJAAoJEODzc/N7+QmaeDoQAJJsOs0DqCPzcmkHEHm2MfIf
dj+4ZU4Cgkt1NC0NRnz0ql+p+K/JHKfYZC2243tkDqNomPoOn7uM69tKRmNrAdvd
7D5RTDnsc1MWwtPGh72mB0WRuyURJ/9w7uRJ7AqiuisHuJYGxeD9mG/uYrMKq020
63CM3O4vay51PbcHNJ0lg5JoTipEfQoy+t9qcerfYOqySCIA0WWXgzJk9L07GVkj
diI9ImWUVml/X0LUXQzn5W0SxTvzvrbT2p2lDS7pHq7X8CD4lOfZTU/L3GjHsAIJ
ni5RDyz+f3++FY4gd4qcdJer9Ld5k2XtQB1z8igwLYJfrysioipHfiTYeKmqPKFm
SBTdbDFpHWwaUBGdSWEsBgspCitc9dzHA5kIAz4XY14UzAAX1wKxv2gTMHNu6K9j
uFTcHy+l60/cLb/8K5OIOYw4c7wKXSbv6g0OdhsOjIoFjcV/IQabKjYWdYo3rZhw
e224SpEG30VrXTFcKlhjJJCiB6gDU+VyBo7d68pcPj0IeLDAny2tXvgw+uSuCTDR
xrnz0J+40OYf8XPzL5R1GkLSMUT3QnpHJ75Tw3IS2/Gc9Z3vOeux6CRQ0EOpaXb7
6t6EZh64IG5aLTEQe2A/Lb120EMeFsoD2JowlbsJd06q2QoC/fDIQYIQHS1eVEA6
BWLXdJLoVFWrrwD93CW2
=O/Ro
-----END PGP SIGNATURE-----

--=-lgssFZmV0Cq1a+PC1EVM--

