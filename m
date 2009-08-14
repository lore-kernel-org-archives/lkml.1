Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbZHNMvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbZHNMvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756721AbZHNMvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:51:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:44710 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbZHNMvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:51:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KtiRoq3bKLHb039hRGkqk3WV3SESoRfRUl4Y2K+VE01RcvP8L68SwulReFmfg5RS6H
         TJQEss6zbVqQSv6SZJ64HLhuHQKXCcbdlAGaDfoAgkyv1XRaSTXm3Vf2pHbjZ8/+O8pz
         mjXeRsC7WqkCYFsZ5gPVPApTSqDUqVoiMSfx4=
Date: Fri, 14 Aug 2009 15:48:05 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Len Brown <lenb@kernel.org>, "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090814124805.GA3209@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
 <20090813124647.GA19195@localdomain.by>
 <1250217283.2987.16.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <1250217283.2987.16.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/14/09 10:34), Lin Ming wrote:
> Could you please help to locate the line of code that causes oops, as
> below?
>=20
Is it possible that we are dereferencing freed pointer?

	Sergey
--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqFXQUACgkQfKHnntdSXjRUbQP/WQg4YxwyY+8fHMWzsOV8hRcV
Tz8O9ZoLWEFcAyjNTfU5MR3f2NSe41FfIpUhvyGBe/ND64/0ixGeVv0GB4gTKs/y
aiftsrHwgWbEnN5XQd/t/XCehBUlvpEXO0y45f2YuDDy/QtUpOvqRrUrDw+vAQFR
r0/oj3aax0NBi5KsfDE=
=bSgb
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
