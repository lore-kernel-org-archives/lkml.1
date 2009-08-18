Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZHRHmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZHRHmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 03:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZHRHmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 03:42:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:38217 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZHRHmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 03:42:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i5UJCe0QwgoNdmclY+wED1gJQlOvmshWFk1Gw/m2HrS/N1Q0kPfACUxoOk7Xd51UBL
         I2XXE0g+sEund1WbNWmxuTwnJ4gZyViewhvm6zus3v9ORmxzgiu/j+UaTzE09bql7Q2g
         A3L0cBarOo91o2PU6tnc208953gV5j4yUWbxU=
Date: Tue, 18 Aug 2009 10:45:37 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090818074537.GA29066@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <1250498613.28336.68.camel@minggr.sh.intel.com>
 <20090817113059.GA3245@localdomain.by>
 <d3f22a0908170622x7dd9ce73m5c3ea86406cc9935@mail.gmail.com>
 <20090818071359.GA3713@localdomain.by>
 <1250579915.13743.8.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <1250579915.13743.8.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/18/09 15:18), Lin Ming wrote:
> On Tue, 2009-08-18 at 15:13 +0800, Sergey Senozhatsky wrote:
> > On (08/17/09 21:22), Lin Ming wrote:
> > > > rc6-git2
> > > > 25 successful reboots.
> > > >
> > > > I'll need some more time to test against rc5.
> > > >
> > > > /*should I also test DSDT in case region-debug.patch fixed the prob=
lem?*/
> > >=20
> > > Yes, please also help to test the custome DSDT.
> > > region-debug.patch is just a debug patch.
> > > We need to root cause the problem clearly and then work out a clean s=
olution.
> > >=20
> >=20
> > Hi, Lin
> > Looks like DSDT didn't solve the problem (oops on 4th reboot).
> >=20
> > So:
> > region-debug.patch	+
> > DSDT			-
> >=20
> > /* Is that possible? */
>=20
> Yes, that is possible.=20
> The same aml method is re-entered when interpreter lock is released.
> So you still see AE_ALREADY_EXISTS error with the custom DSDT, right?
> Thanks for the info, I'll continue to look at this issue.
Wait a minute, Lin. I can't see ...[DSDT] replaced... in syslog.
I'll recompile.

> And would you please test the region-debug.patch multiple times to
> verify if it really fixes the bug?
>=20
Sure.

	Sergey
--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqKXCEACgkQfKHnntdSXjTKFQQApU3ma4K+Dhlzz0JiJLS7KO80
8IYkDM9ttfC7THaxCR1V4l/T4CrJfyPybERvleCrJBWQd1UL3xzJpbRdBFkOh3+k
GiQs3d/4Ss8AsdFKtL6eDZLGs4hMzFm4/mcG+EljMLEX0u3FbwMloru79dYslpZ5
EjuJpWjEbJGSI9VM1S0=
=uA6e
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
