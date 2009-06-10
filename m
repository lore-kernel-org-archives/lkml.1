Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbZFJIYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbZFJIYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZFJIYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:24:20 -0400
Received: from mail.technotrend.de ([212.185.20.147]:36982 "EHLO
	mail.technotrend.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbZFJIYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:24:18 -0400
Date: Wed, 10 Jun 2009 10:24:17 +0200
From: Martin Zwickel <martin.zwickel@novabasedigitaltv.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Zwickel <martin.zwickel@novabasedigitaltv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: FDTI-SIO: kernel-oops after resume
Message-ID: <20090610082417.GA32313@novabasedigitaltv.de>
Reply-To: Martin Zwickel <martin.zwickel@novabasedigitaltv.de>
References: <20090609063948.GA17564@novabasedigitaltv.de> <20090610005018.2c84d229.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20090610005018.2c84d229.akpm@linux-foundation.org>
X-Operating-System: Linux dieter 2.6.29.3-Xeno 
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 10, 2009 at 08:50:18AM +0100, <Andrew Morton> bubbled:
> On Tue, 9 Jun 2009 08:39:48 +0200 Martin Zwickel <martin.zwickel@novabase=
digitaltv.de> wrote:
>=20
> > My kernel runs with SMP and HIGHMEM if it matters:
> > Linux tt-business 2.6.29.4 #3 SMP PREEMPT Fri Jun 5 00:03:39 WEST 2009 =
i686 Intel(R) Core(TM)2 Duo CPU T7300 @ 2.00GHz GenuineIntel GNU/Linux
> >=20
>=20
> The oops is very very similar to the one which Daniel Mack reported,
> and which was fixed by
>=20
> commit c16199fcd341f10147eb2e29a60aed41ceca55b4
> Author: Alan Stern <stern@rowland.harvard.edu>
> Date:   Thu Apr 30 10:06:19 2009 -0400
>=20
>     usb-serial: ftdi_sio: fix reference counting of ftdi_private
>=20
> but your 2.6.29.4 contained that fix, so it seems that we still have a
> problem here?

Could be, or I'm doing something wrong.

I will clean the kernel, rebuild 2.6.29.4, reboot, try to crash it and
let you know.
If I should try some patches, please let me know.

Best regards and thanks,
     Martin

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkovbbEACgkQ/XnDWy8tQ2c8rgCfVvAg0HmXpOPY5tMNZaAPU2ui
018An0r1VrP3egwZjPf3D/xmXSFiUogy
=jAbK
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
