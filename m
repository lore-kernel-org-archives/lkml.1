Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbZJKPEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbZJKPEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 11:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZJKPEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 11:04:10 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:36699
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbZJKPEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 11:04:09 -0400
X-Greylist: delayed 689 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Oct 2009 11:04:09 EDT
Date: Sun, 11 Oct 2009 11:44:19 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, lenb@kernel.org
Subject: Re: [PATCH -mmotm] cmpc_acpi: depends on ACPI
Message-ID: <20091011144418.GF30257@vespa.holoscopio.com>
References: <200910090830.n998Ubvv020464@imap1.linux-foundation.org> <20091009161036.7f752529.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R6sEYoIZpp9JErk7"
Content-Disposition: inline
In-Reply-To: <20091009161036.7f752529.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R6sEYoIZpp9JErk7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 09, 2009 at 04:10:36PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Fix about 100 build errors/warnings when ACPI is not enabled.  E.g.:
>=20
> drivers/platform/x86/cmpc_acpi.c:50: error: dereferencing pointer to inco=
mplete type
> drivers/platform/x86/cmpc_acpi.c:55: error: dereferencing pointer to inco=
mplete type
> drivers/platform/x86/cmpc_acpi.c:56: error: dereferencing pointer to inco=
mplete type
> drivers/platform/x86/cmpc_acpi.c:72: warning: 'struct acpi_device' declar=
ed inside parameter list
> drivers/platform/x86/cmpc_acpi.c:77: error: dereferencing pointer to inco=
mplete type
> drivers/platform/x86/cmpc_acpi.c:79: error: dereferencing pointer to inco=
mplete type
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

> ---
>  drivers/platform/x86/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- mmotm-2009-1009-0107.orig/drivers/platform/x86/Kconfig
> +++ mmotm-2009-1009-0107/drivers/platform/x86/Kconfig
> @@ -438,7 +438,7 @@ config ACPI_TOSHIBA
> =20
>  config ACPI_CMPC
>  	tristate "CMPC Laptop Extras"
> -	depends on X86
> +	depends on X86 && ACPI
>  	select INPUT
>  	select BACKLIGHT_CLASS_DEVICE
>  	default n

--R6sEYoIZpp9JErk7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrR70IACgkQyTpryRcqtS1y5QCfZlCSFMxJAJgkQrKISXhTsB0X
9hcAn3zh5P7l32/8Z9shFZ6k649GMuZ9
=/ulM
-----END PGP SIGNATURE-----

--R6sEYoIZpp9JErk7--
