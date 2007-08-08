Return-Path: <linux-kernel-owner+w=401wt.eu-S933730AbXHHKEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbXHHKEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932518AbXHHKDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:03:14 -0400
Received: from thb8.jinr.ru ([159.93.129.8]:50979 "EHLO theor.jinr.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932487AbXHHKDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:03:12 -0400
X-Greylist: delayed 695 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2007 06:03:12 EDT
Date: Wed, 8 Aug 2007 13:51:32 +0400
To: Andi Kleen <andi@firstfloor.org>
Cc: dragoran <drago01@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: allow non root users to set io priority "idle" ?
Message-ID: <20070808095132.GA31020@theor.jinr.ru>
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <p73zm14lxyy.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: varg@theor.jinr.ru (Sheplyakov Alexei)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 06, 2007 at 01:11:01PM +0200, Andi Kleen wrote:

> Very low priority can starve others when it holds some kernel resource
> needed by another task. =20

Nevertheless ordinary users are permitted to lower priority ([re]nice)
and resource limits (setrlimit).

> For IO I suppose the same could happen too. e.g. low priority
> task wants to write out a page and keeps it locked until the IO=20
> is finished. High priority task wants to access the page and has
> to wait until it is unlocked. Middle task generates an endless
> stream of IO that makes the idle priority writeout never finish.

I don't quite understand. There are a lot of other ways to starve such
high-priority process:=20
1. renice the low-priority process
2. send it a signal
3. ptrace it
4. use something like cpulimit (http://cpulimit.sourceforge.net/) to stall =
it
=2E...

So I think current behaviour of ionice is inconsistent (and pointless).

P.S.=20
Please CC me, I'm not subscribed.

Best regards,
 Alexei

--=20
All science is either physics or stamp collecting.


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQIVAwUBRrmSIyXMWnuYxRVqAQKZaA//cCN26rGNiu0y4u+gCe/y/5zUzrn8AiIl
zjkriUMLFVnjqJkKlkB1XAR1SpLMd1bzyJpTDlNmfadcBbyXBgq+R5Iek/ZU/4So
Kh0VKNUbYWCc2QBjQI+YT0Jnykbh++w4XqamV076QXoC02bt3hBqY5wTQpzocxp+
CL/yjtBSg77IEDCEuWpc3pSMlS3HLkpJZU23GrkPPGnxeVa5I1Q+O5LkYemsDII8
RBHHMCUP+aFjTyG81y6scOapDuJrbof4eH/qeOMKfcdf+qFzWyGkJTaD869eUUbf
ojsZUdjJ3ZVEIaupAW3Tr3/+xwy286qQwgMvdr8TPjKH/zyqQ02X4w4sMVzvl5aA
E6tntEGh3+hRAbK5Qs++r9rq+De4unqhfltAzg7rCTS8pXkuDASEL7h0jGeqwHlK
FZs9GSk80ptowN2At77Me3S5JJ8rCSrF4kjnxj9eSYbqhlqJvgEnZDRFTdQwmeoJ
VMqkWZGcEZNuEI6k0ldCSCtg/grIyohH3utH6Uvnz1H3LCm5TCOc3MvhVYpHuuZI
PkF6QV6eRoRDqpf86GL10K3jyJvl/MTsbNN6qd66cXn/jTiV9sd/J4vIEuWIH/Pz
oirUvveYL5GKsYucLME3TIxOIzB2saO+VD3c0THR2QWJ2Wb08gnFODdlDxo4xPbh
ozPW3lToJK8=
=+fiB
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
