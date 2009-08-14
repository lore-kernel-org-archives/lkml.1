Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbZHNJIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbZHNJIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 05:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZHNJIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 05:08:46 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:51465 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZHNJIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 05:08:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vzU32wxYlVA5qFdRrqPuXKQDMzjkAJvcBsM0nnR6A0chtBOlNoUcTXpIzG5RGmdoCX
         hJXZONXmLtl5kWW+LagSg/Zn6riF2s4tScZy7SauotFhcmYzW2CFd+dM9/HejAtZElgq
         s5sG2FqCETWa3QA04jByhN5B012iYs/9gwXYI=
Date: Fri, 14 Aug 2009 12:12:02 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Len Brown <lenb@kernel.org>, "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090814091202.GB3545@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
 <20090813124647.GA19195@localdomain.by>
 <1250217283.2987.16.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline
In-Reply-To: <1250217283.2987.16.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

>which I belive is (marked with __):
>        /*
>         * Does the request fit into the cached memory mapping?
>         * Is 1) Address below the current mapping? OR
>         *    2) Address beyond the current mapping?
>         */
>        if ((__ address __ < mem_info->mapped_physical_address) ||
>            (((acpi_integer) address + length) > ((acpi_integer)
>

I was wrong. Sorry.

	Sergey

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqFKmIACgkQfKHnntdSXjT7OwP+Mp308FS3KFmfIOfYdXL12Kze
nHgVGZrTkc7aOUQtzxWNL6pmJiCHINACvh4MVKVOJpqIiKBRLNboZ5fu/+6tQWoR
rSToH8KbQNeMtquXfAwlwMcR1tuwX0cxUBaCZTAXBaAPWRZ2gejf6RUmRvXqM8jj
utSR6B7HUKKhD1Gc3U0=
=5IU9
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
