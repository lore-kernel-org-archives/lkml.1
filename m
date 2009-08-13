Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbZHMMnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbZHMMnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 08:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbZHMMnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 08:43:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:5340 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbZHMMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 08:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Yhn0YO+KWpStjrxnwE+371exXJXtJlL0i0LOYj1dvXzQgQCSw0X0oHHxpWv9b3eoDj
         odP9cGj8PvhOJn4KMDZFEE26HreQgz4OOwXeBMHGiNqwy5r5vMXHcuxQOSpheMntfihb
         pin5w3m79kkhxamsyNjUUcDlkee8ULPelBO+s=
Date: Thu, 13 Aug 2009 15:46:47 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090813124647.GA19195@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Looks like regression is in the current RC.

Looks like it isn't. On 17th reboot rc5-git0 crashed.
(I'll recompile and try more.)
I think bisecting here is kind of senseless. You never know how much reboot=
s you need.
Simple delay (like vga=3D791) - and everything is ok. We need to come up wi=
th something=20
more clever, I guess.

Any thougths?

	Sergey
--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqECzcACgkQfKHnntdSXjRzxAQAwSiILqK8tSW586mdem1FZefu
gYnqzwagUI7YmSyRwrtXYJMNo0jBsMSSoEm9wHuCk3euMKaNSa9HugGVtZGtKW3a
i30UVWCHtFI84DATrGckMDIjwGDq3NgO7SsAhC/CA4RAtkUbuTsiPYn+tDRwc2V3
jGc7tEVrynri3CkunvA=
=iZvp
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
