Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbZJKJRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbZJKJRN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZJKJRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:17:11 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45668 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014AbZJKJRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:17:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=jhQRJrvxztUWverLYUgIvptTqsz1h2CPY/ddjN+kmmyKLQxCYldohRfREv6aR45cW+
         wvPcLOUfsInlIHr7DvmrPdLhbp1kfMNB/o4haZ/mJyyR+1uG9J39oeWKFiFkBefYLFeR
         /QeVqMHjq9BWE9N6WAObIGZ3gLA+yVgSFX74k=
Date: Sun, 11 Oct 2009 12:17:12 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org
Subject: Re: [Intel-gfx] [bisected] i915: linux-2.6.32-rc3+ regression
Message-ID: <20091011121712.480128d6@mosly>
In-Reply-To: <21d7e9970910101456m277a3c31k3a1add039fcae9d6@mail.gmail.com>
References: <20091010213722.051a60dc@mosly>
	<1255210017.3692.24.camel@maxim-laptop>
	<200910102347.04579.rjw@sisk.pl>
	<21d7e9970910101456m277a3c31k3a1add039fcae9d6@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//V2VLIr.9a.Gn79txhgDnqF"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//V2VLIr.9a.Gn79txhgDnqF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 11 Oct 2009 07:56:01 +1000
Dave Airlie <airlied@gmail.com> wrote:

> Are you running X.org server 1.7 + driver? if so there is a bug in the cu=
rrent
> released driver between that combination, the fix is on the intel-gfx
> mailing list.
>=20
> The 1.6 X server + same driver doesn't show this problem.
Yes, both driver and xorg-server are current -git masters.

Patch http://lists.freedesktop.org/archives/intel-gfx/2009-October/004488.h=
tml
helped me.

Thanks!

> Dave.
>=20

--=20

  Sergei

--Sig_//V2VLIr.9a.Gn79txhgDnqF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrRopwACgkQcaHudmEf86ppDACdEhfBJv+0Hli5A8rY/rKvZWVG
Cw0An0wP2THG9NcXK6+Bk/YqMQX5SYXM
=yvVe
-----END PGP SIGNATURE-----

--Sig_//V2VLIr.9a.Gn79txhgDnqF--
