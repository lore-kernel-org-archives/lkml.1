Return-Path: <linux-kernel-owner+w=401wt.eu-S1764427AbZLQLD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764427AbZLQLD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 06:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764413AbZLQLDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 06:03:53 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:58549 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764375AbZLQLDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 06:03:41 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/9] pci: separate pci_setup_bridge to small functions
Date: Thu, 17 Dec 2009 12:03:22 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.80; i686; ; )
Cc: Yinghai Lu <yinghai@kernel.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
References: <4ADEB601.8020200@kernel.org> <4B10D29F.2000800@kernel.org> <20091216124147.4163cd10@jbarnes-piketon>
In-Reply-To: <20091216124147.4163cd10@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1946333.LLi9HJaeNg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200912171203.29367.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1946333.LLi9HJaeNg
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Jesse Barnes wrote:
> On Fri, 27 Nov 2009 23:34:55 -0800
>=20
> Yinghai Lu <yinghai@kernel.org> wrote:
> > prepare to use those small functions according to resource type later
> >
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >
> > ---
> >  drivers/pci/setup-bus.c |   54
> > +++++++++++++++++++++++++++++++++++++++--------- 1 file changed, 44
> > insertions(+), 10 deletions(-)
>=20
> Seems like a reasonable cleanup, anyone have objections?

There are some newlines missing between some functions, e.g. before =20
pci_setup_bridge_mmio().

Eike

--nextPart1946333.LLi9HJaeNg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAksqEAEACgkQXKSJPmm5/E58wQCfWOpgejKq9PpLfKhIaNzzcHE7
SPUAnjH6GLgI16kvPLKyWYmU5/7RFZew
=itAm
-----END PGP SIGNATURE-----

--nextPart1946333.LLi9HJaeNg--
