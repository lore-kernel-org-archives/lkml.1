Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZHNJfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZHNJfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 05:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZHNJfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 05:35:04 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:57473 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZHNJfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 05:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T1oB+MQAjnWniuSiosHSEOPTUEZiS29SArnEDv9mwGrrM/Si03TYTqYqO8EfrQ5bOa
         0L5i7LwMCpnCVkP4y8cqLlGUxf/yFmg/fcEVjrfZG8TPI1S5cI8/nF0rmMobmryKL3GB
         KRu6aPEJ8roovOm0i8G1Lo8Ot8fsXOHWX6KsU=
Date: Fri, 14 Aug 2009 12:38:18 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Len Brown <lenb@kernel.org>, "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090814093818.GD3545@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
 <20090813124647.GA19195@localdomain.by>
 <1250217283.2987.16.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BZaMRJmqxGScZ8Mx"
Content-Disposition: inline
In-Reply-To: <1250217283.2987.16.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BZaMRJmqxGScZ8Mx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I suspect we are dereferencing NULL pointer:
mov    0x8(%ebx)

which is mem_info->mapped_physical_address.

	Sergey
--BZaMRJmqxGScZ8Mx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqFMIoACgkQfKHnntdSXjSI6AQAzzYtF5CbfCmcje1XEA+gy7P6
DXxsXjAEVfp2bJijmveSIKoFtGsGU39h5o5Vd1GuVzxagG4QrLlAjwiP9zR6EXz7
LjbDIlvrVFY6FTGwWWhhlge0IwZoLNEkgy22zSsCE/+blIXNJs24l90fsjsIZP9M
ZpErppwGfPKXfn2kCA0=
=Fqeo
-----END PGP SIGNATURE-----

--BZaMRJmqxGScZ8Mx--
