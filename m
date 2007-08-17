Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbXHQHrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbXHQHrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbXHQHrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:47:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46070 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755AbXHQHrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:47:17 -0400
Date: Fri, 17 Aug 2007 17:46:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Blanchard <anton@samba.org>, "Ryan S. Arnold" <rsa@us.ibm.com>
Subject: Re: [PATCH] Only initialize hvc_console if needed, cleanup Kconfig
 help
Message-Id: <20070817174653.eae71040.sfr@canb.auug.org.au>
In-Reply-To: <1187313946.6449.68.camel@localhost.localdomain>
References: <20070816201649.GA5375@redhat.com>
	<1187313946.6449.68.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Aug_2007_17_46_53_+1000_273V.KTjso7zaqQF"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Aug_2007_17_46_53_+1000_273V.KTjso7zaqQF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Aug 2007 11:25:46 +1000 Rusty Russell <rusty@rustcorp.com.au>
wrote:
>
> diff -r 0730da2377be drivers/char/Kconfig
> --- a/drivers/char/Kconfig	Tue Aug 14 12:46:08 2007 +1000
> +++ b/drivers/char/Kconfig	Fri Aug 17 09:05:12 2007 +1000
> @@ -568,10 +568,10 @@ config HVC_DRIVER
>  config HVC_DRIVER
>  	bool
>  	help
> -	  Users of pSeries machines that want to utilize the hvc console front-=
end
> -	  module for their backend console driver should select this option.
> -	  It will automatically be selected if one of the back-end console driv=
ers
> -	  is selected.
> +	  Generic "hypervisor virtual console" infrastructure for various
> +	  hypervisors (pSeries, Xen, lguest).
                      ^^^^^^^^^^^^^^^^^^^^^^^
You left out iSeries.  Probably better to just not enumerate them as they
may increase over time.

Otherwise looks good (though I haven't actually built/booted it).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Aug_2007_17_46_53_+1000_273V.KTjso7zaqQF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGxVJ6TgG2atn1QN8RAnYjAJ9qc7YYxzJQ9hGpmKbZMF97OCHMAQCdHTr6
PlFdIeKOEFuK//U5Vtb6FxA=
=Gpr/
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Aug_2007_17_46_53_+1000_273V.KTjso7zaqQF--
