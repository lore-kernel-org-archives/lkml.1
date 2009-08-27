Return-Path: <linux-kernel-owner+w=401wt.eu-S1751886AbZH0JBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbZH0JBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZH0JBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:01:48 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:57347 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbZH0JBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:01:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vdiii+Yh4IYG5wUJqcaxfHMrlKItFA7EJQQrOXdbN3dWKLQd4oA9CC7qTPOzIjFIwQ
         7FUZ0i07pAj8doricep5xB/oih0Nb9EkGJ4CdFTkQLz1kJa4prLnANB1w5uoGTfUJM5+
         zDMQEXxAXdC0LXYBQy8fJbrn78hQ3vMQ4F/Ns=
Date: Thu, 27 Aug 2009 12:05:31 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090827090531.GB3075@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <1250498613.28336.68.camel@minggr.sh.intel.com>
 <20090817113059.GA3245@localdomain.by>
 <d3f22a0908170622x7dd9ce73m5c3ea86406cc9935@mail.gmail.com>
 <20090818071359.GA3713@localdomain.by>
 <1250579915.13743.8.camel@minggr.sh.intel.com>
 <20090827075253.GB3536@localdomain.by>
 <1251359994.3282.11.camel@minggr.sh.intel.com>
 <20090827082927.GD3536@localdomain.by>
 <1251362657.3282.19.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline
In-Reply-To: <1251362657.3282.19.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/27/09 16:44), Lin Ming wrote:
> > > > [    0.178628] ACPI: EC: Look up EC in DSDT
> > > > [    0.196480] ACPI: Interpreter enabled
> > > > [    0.196575] ACPI: (supports S0 S1 S3 S4 S5)
> > > > [    0.197184] ACPI: Using IOAPIC for interrupt routing
> > > > [    0.197352] PCI: MCFG configuration 0: base e0000000 segment 0 b=
uses 0 - 255
> > > > [    0.203511] ACPI Error (dswload-0790): [PCFG] Namespace lookup f=
ailure, AE_ALREADY_EXISTS
> > > > [    0.203738] ACPI Exception: AE_ALREADY_EXISTS, During name looku=
p/catalog 20090521 psloop-227
> > > > [    0.203964] ACPI Error (psparse-0537): Method parse/execution fa=
iled [\_SB_.RBPE] (Node f7017678), AE_ALREADY_EXISTS
> > > > [    0.204256] ACPI: Marking method RBPE as Serialized because of A=
E_ALREADY_EXISTS error
> > > > [    0.204510] ACPI Error (psparse-0537): Method parse/execution fa=
iled [\_GPE._L01] (Node f701d198), AE_ALREADY_EXISTS
> > > > [    0.204803] ACPI: Marking method _L01 as Serialized because of A=
E_ALREADY_EXISTS error
> > > > [    0.205063] ACPI Exception: AE_ALREADY_EXISTS, while evaluating =
GPE method [_L01] 20090521 evgpe-568
> > >=20
> > > Do you mean rc7-git5 sometime boot fails even with the patch applied?
> > >
> > No. Patched kernel boots ok. Even successfully booted kernel sometimes =
has the given lines in dmesg.
> > (I'll watch more.)
>=20

Yes, looks like:

> So the patch only fixes the oops,=20
confirmed;

> we also need to fix the AE_ALREADY_EXISTS error.
>=20
AE_ALREADY_EXISTS fix not confirmed.=20
(AE_ALREADY_EXISTS errors are quite rare.)


	Sergey

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqWTFsACgkQfKHnntdSXjRLYAQApejkO1KAP8yI1Oaki/dKtKxT
adUrMkwsfnSvLTWBApWt53I8tmTTFwBcSF0cJbzxTJ4d9C+2Mcp6fwaTbBZYN0sE
10388zWf2KRO5/Hkw9j/n9+tc/XPvzxqFg7umSqEyih1zTNZMd30TGQWyzfI/ok/
GVQIvqhHJyQzKeF0VmU=
=TO/l
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
