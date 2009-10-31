Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZJaGe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZJaGe6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 02:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZJaGe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 02:34:58 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40903 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZJaGe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 02:34:57 -0400
Subject: Re: OOPS in cfg80211_conn_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
In-Reply-To: <f7848160910301622t2cf43b5bo5ffeda03ec2cdbfe@mail.gmail.com>
References: <f7848160910291617q2b168089l5ce489d2f47ebe96@mail.gmail.com>
	 <1256885343.3555.0.camel@johannes.local>
	 <alpine.DEB.2.00.0910300652350.2223@parag-laptop>
	 <1256903425.3555.47.camel@johannes.local>
	 <f7848160910301622t2cf43b5bo5ffeda03ec2cdbfe@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-m4m3CTRSo2XZEoWk/TF7"
Date: Sat, 31 Oct 2009 07:34:59 +0100
Message-ID: <1256970899.3555.86.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-m4m3CTRSo2XZEoWk/TF7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-30 at 19:22 -0400, Parag Warudkar wrote:

> Seems to have fixed it.

Thanks Parag. Could you run

iw event -t -f > /tmp/log

[http://linuxwireless.org/en/users/Documentation/iw]

and try to reproduce again? I'm not sure whether or not we get spurious
events with this patch.

johannes

--=-m4m3CTRSo2XZEoWk/TF7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK69qMAAoJEODzc/N7+QmaucMP/1y5L18njsZ4SezLJ1dPi4f0
K3bbnxz49XnlKwMoJ/48nJrJdtSq43cPwaTKVLKebewYq2yaP8+bLdhfGQkDBiXq
jUoQrUCkJnKDS5ZI5s2iPptu86iuehVwIaHfntsnXxf5Pop/oKiM4Iwe/OHimUli
D1Dlf7dxFXLbWKiDn0Ug6KJ4EG3okgqleS7z4K4qttNzaLTjEYFoZUDmZ17tovEs
/NNz08QXmSBGqK6gk669MVXM8z1Wbhg/Y9ZDj4mx+vAWLK9yIFVUMrbhMVRkXYCQ
4uaeaTQnc2R6Y0sYGdhhts0zV51ZsnbhS2yP2mYfKee3IXBe5nbNTT1RGOIrJsvT
vI9yUoXmNojCRx7sj7nzL9fXg46OAUeKy1LRtPocUyzFrFpYPHf9r+1oLUqn+Js3
1N12PbHA5+RVk4QTEwVV1qllyro/klkPoaplBAg5U9dr8MWQMYpBCyuO/EKtvOqv
4sWkbobugIzWlJqsGM0jF760lrxxo6BESMdSzLNcJir9fEzqPiwoulXz5hUaZC4p
+5+Xuvsqngs3eYj/MiVusV4JPjov1IkmgRsFajwaOQ0VJ92pB6mbJ+qDIZkPFyb7
lEB+riy+IUck9I6FBDwDlSTnZcBGDNii+IT1nhCh5+43clxQEBDl0xx+FMe1W2hf
U4lfCx/8vl0eURiefL/d
=WQEg
-----END PGP SIGNATURE-----

--=-m4m3CTRSo2XZEoWk/TF7--

