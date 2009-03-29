Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZC2JNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZC2JNY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 05:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZC2JNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 05:13:13 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:45344 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbZC2JNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 05:13:11 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-02.arcor-online.net 9E2483FE377
From: Prakash Punnoor <prakash@punnoor.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: don't enable too much HT MSI mapping -v5 -resend
Date: Sun, 29 Mar 2009 11:15:53 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8; KDE/4.2.1; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200903282316.55142.prakash@punnoor.de> <49CECFCF.8060403@kernel.org>
In-Reply-To: <49CECFCF.8060403@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1337132.GHpFeGMOEy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903291115.54351.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1337132.GHpFeGMOEy
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sonntag 29 M=E4rz 2009 03:33:03 Yinghai Lu wrote:
> please try follwing patch over pci/linux-next
>
> Thanks
>
> YH
>
> [PATCH] pci: don't enable too much HT MSI mapping -v6

Works fine now, thanks!

pci 0000:00:00.0: Found disabled HT MSI Mapping                            =
                                                          =20
pci 0000:00:00.0: Enabling HT MSI Mapping                                  =
                                                          =20
pci 0000:00:00.0: Found enabled HT MSI Mapping                             =
                                                          =20
pci 0000:00:05.0: Boot video device                                        =
                                                          =20
pci 0000:00:09.0: Found disabled HT MSI Mapping                            =
                                                          =20
pci 0000:00:0e.0: Enabling HT MSI Mapping                                  =
                                                          =20
pci 0000:00:09.0: Found disabled HT MSI Mapping                            =
                                                          =20
pci 0000:00:0f.0: Enabling HT MSI Mapping                                  =
                                                          =20
pci 0000:00:09.0: Found disabled HT MSI Mapping                            =
                                                          =20
pci 0000:00:10.0: Enabling HT MSI Mapping                                  =
                                                          =20
pci 0000:00:09.0: Found disabled HT MSI Mapping                            =
                                                          =20
pci 0000:00:10.1: Enabling HT MSI Mapping

So drop my patch and merge v6 of Yinghai Lu's one.


Cheers,

Prakash

--nextPart1337132.GHpFeGMOEy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAknPPEoACgkQxU2n/+9+t5h5egCgt36ZSZogkEvhy3aaDMLN9USK
WlEAoLNbwdO+F0eASmXaD2Ney4vuasPi
=es5P
-----END PGP SIGNATURE-----

--nextPart1337132.GHpFeGMOEy--
