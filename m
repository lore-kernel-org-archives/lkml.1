Return-Path: <linux-kernel-owner+w=401wt.eu-S1761988AbXFTEc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761988AbXFTEc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 00:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbXFTEct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 00:32:49 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42831 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbXFTEcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 00:32:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH] remove usage of memmem from scripts/kallsyms.c
Date: Wed, 20 Jun 2007 00:33:15 -0400
User-Agent: KMail/1.9.7
Cc: "Paulo Marques" <pmarques@grupopie.com>, "Andrew Morton" <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <4678013C.5090402@grupopie.com> <a781481a0706191147x72be6357vf0c83808b13174b8@mail.gmail.com>
In-Reply-To: <a781481a0706191147x72be6357vf0c83808b13174b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2027308.Klxhedck65";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706200033.16708.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2027308.Klxhedck65
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 19 June 2007, Satyam Sharma wrote:
> On 6/19/07, Paulo Marques <pmarques@grupopie.com> wrote:
> > The only in-kernel user of "memmem" is scripts/kallsyms.c and it only
> > uses it to find tokens that are 2 bytes in size. It is trivial to
> > replace it with a simple function that finds 2-byte tokens.
> >
> > This should help users from systems that don't have the memmem GNU
> > extension available.
>
> So we could remove the "#define _GNU_SOURCE" at the top
> of scripts/kallsyms.c too, presumably? If not (i.e. if there are
> more GNUisms left in that file anyway), then I'm not sure if we
> really gain by the change.

yes, i believe this is true
-mike

--nextPart2027308.Klxhedck65
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARniuDEFjO5/oN/WBAQI+wA//bTn3gzl5l5QZbWU/qfp9A55acKc1dtFV
yU9bs+8lf/Q1eCIm9Op1+7HFq3ArPZMNC4RKwZfgQaIa1sNfCnjvySlQAAdVrRCJ
2Xg8WIrU/xI4ihYmlWzRb8EoZafZShM05RhQVQzdLQmbfYaElvR4j4cQwYy+SWFV
Dkbrr8o7k8Hz1nenP2gJDlbzbn541Eydgrh5O/2Q4h5OO7VZ42eR8RMY+BFIO80C
nNdkezB7dA0KJC4amYaS3p7EafG2L/M0+sZfxnG0B0ybHG3o04sllKDCvrT1SMrX
we9DTGc4C/boJYcyY+v/7Q2ho+l4skhpzf7Gbt5NqMBkaOVy4MhRNHSirJfEVEci
KsugQRghr5zdREKDxihlFL7O+IwaUsfbZf+VQltgnBoFXNgvSb/eUo5ll2foqcrQ
MUU71uIeciShx+kBuQDYhbJCe/sg0Q3t6G1hHL3c+XhoMUdUvCe4sZViJeJ4KVQ4
Tau0JObjwo2RhSBpzzGEVMbPXNwbfFj7Xib6HGhaLkdacPrcGr6u+d65LV7hK3XF
xL9c6G21lpj9zBj6nQam2QT8AGh4HzK5OfG/dVkv096jDw1yWRBtr4C1In+BIeme
6UsTtsDMt5CT/BAStbgikT+ggs7YU8i6HhmBz90+ycpVJ9TscmVIOh1YOuHslI97
TdLNi9N3SOQ=
=SaTI
-----END PGP SIGNATURE-----

--nextPart2027308.Klxhedck65--
