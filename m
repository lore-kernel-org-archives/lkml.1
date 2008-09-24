Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYIXSNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYIXSNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYIXSNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:13:24 -0400
Received: from bavaria.utcluj.ro ([193.226.5.35]:50268 "EHLO bavaria.utcluj.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbYIXSNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:13:22 -0400
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
From: Cristi Magherusan <cristi.magherusan@net.utcluj.ro>
Reply-To: cristi.magherusan@net.utcluj.ro
To: Yan Li <elliot.li.tech@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, joerg.roedel@amd.com,
       rjmaomao@gmail.com, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
In-Reply-To: <20080924142322.GA21049@yantp.cn.ibm.com>
References: <48D12490.5010003@zytor.com>
	 <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com>
	 <1222265424.5708.5.camel@localhost>
	 <20080924142322.GA21049@yantp.cn.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IH0m2sdDBsGgzsgiWbQ0"
Organization: Universitatea Tehnica din Cluj-Napoca, Centrul de Comunicatii
	"Pusztai Kalman"
Date: Wed, 24 Sep 2008 21:13:14 +0300
Message-Id: <1222279994.27604.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IH0m2sdDBsGgzsgiWbQ0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-24 at 22:23 +0800, Yan Li wrote:=20
> On Wed, Sep 24, 2008 at 05:10:24PM +0300, Cristi Magherusan wrote:
> > On Wed, 2008-09-24 at 20:22 +0800, Yan Li wrote:
> > > Detects whether we are running as a VMware guest or not. Detection is
> > > based upon DMI vendor string.
> > >=20
> > > It provides a function:
> > > int is_vmware_guest(void)
> > > that can be used easily to detect if we are running as a VMware guest
> > > or not.
> >=20
> > We can also use this feature to force the HZ value to 100 or 250 at mos=
t
> > when running in a virtual environment, since VirtualBox had some issues
> > with this by taking a lot of CPU time when the HZ was set to 1000.
>=20
> That's good. But this function is used for detecting VMware guest
> only.  Do you think VMware also suffers from this problem?
>=20
I don't know for sure about VMware, but someone who has it installed can
try it. I had this issue with a CentOS 5-server virtual machine
downloaded from http://www.thoughtpolice.co.uk/vmware/

The fix consisted in using a kernel compiled with the HZ value set to
100 instead of the default which was 1000.

Cristi

--=20
Cristi M=C4=83gheru=C8=99an,
Inginer de sistem/retea
Universitatea Tehnic=C4=83 din Cluj-Napoca
Centrul de Comunica=C8=9Bii "Pusztai Kalman"
Tel. 0264/401247  http://cc.utcluj.ro

--=-IH0m2sdDBsGgzsgiWbQ0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjagzoACgkQfwrBISYVZFWDWwCePyAPUGRuG0+J6U89tYDQluJR
GFwAoIbCwKpPYIEU1bYSPi0sIAVGA58C
=0ePk
-----END PGP SIGNATURE-----

--=-IH0m2sdDBsGgzsgiWbQ0--

