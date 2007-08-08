Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbXHHLuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbXHHLuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 07:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXHHLtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 07:49:55 -0400
Received: from thb8.jinr.ru ([159.93.129.8]:42200 "EHLO theor.jinr.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751573AbXHHLtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 07:49:55 -0400
Date: Wed, 8 Aug 2007 15:49:49 +0400
To: Andi Kleen <andi@firstfloor.org>
Cc: dragoran <drago01@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: allow non root users to set io priority "idle" ?
Message-ID: <20070808114949.GA8465@theor.jinr.ru>
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de> <20070808095132.GA31020@theor.jinr.ru> <20070808102056.GC12861@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <20070808102056.GC12861@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: varg@theor.jinr.ru (Sheplyakov Alexei)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 08, 2007 at 12:20:56PM +0200, Andi Kleen wrote:

> > I don't quite understand. There are a lot of other ways to starve such
> > high-priority process:=20
> > 1. renice the low-priority process
>=20
> That requires user action.

As well as lowering IO priority.=20

> > 2. send it a signal
> > 3. ptrace it
>=20
> Only root can do these.

The original question (unless I'm missing something) was "why _the owner_
of a process is not enabled to lower its IO priority?" The owner of the
process certainly can send signal and ptrace it.

> Low priority as allowed by renice is ok -- the resource holder will=20
> run eventually and the system make progress.

System (whatever that means) should not depend on random users' processes.

> e.g. if you google a bit you can find a famous story where the NASA
> had to do that remotely to solve a PI problem on one of the Mars rovers.

Certainly there are a scenarios when lowering priority (CPU or IO) have=20
negative effect. "If it hurts -- then don't do it". However, it is not
kernels job to decide if the user is right. If the user asks to do
something "stupid" (run his process with idle IO priority, whipe out his
home directory, you name it) -- just do that (as long as the action is=20
permitted by the security policy).

P.S.=20
Please CC me, I'm not subscribed.

Best regards,
 Alexei

--=20
All science is either physics or stamp collecting.


--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQIVAwUBRrmt3SXMWnuYxRVqAQJt1xAAmxhNZLMNoGeQRWSdeePJOujD+PvCLlx2
KlH8QuBAKloTSae0NLIlCDLd39rTwajTM6dJDfaVU2yN8LQPPodiVeGfE0H7di8V
CLt2LT8UlxZ7XddXx85O25zxzFj/IV02Rvj5GIn9gdNeohiZPf/2esc/rn4rnSmZ
/z9CrGp15i2dKOC8DTS6TWKlpDI/80k/Q+fgkjEaW+5V9r4D9iNQitPJylXgLs8c
dogDyoS22XLYjtPaIQVQmljKuJqMYQ0RRGexg4rAXITMzqgmikFESxdnqMOFKYC4
/22X9VTnR8rRmbAgh6jPoCsrv3i/l4w/tQFDIn4YFiQFQ/1SLrsgUIPUC4eHtSAA
q6JPySzSMnfPRqNBwzpPKU5dnKhVMey1RJCevPdkbLjHD5XIyt5Oi3p7ruSrxfmg
fVRdDB65YPaobtj3Ig9/+qrPbOOIMthFYn0OIU1gBOtWKrmIa9r9I1CitMWMzxAd
pmF6efAP4Jmy0CjKmf0uOds8K+VRXGf+AQXeFobSG5Ew8OPfZVGaUTzvcg4r47q1
GVFxIh9XOm/geD/QSSaQAslFNuJTS31x27ECHxguRut4XnvViHLmngdP6DOhKbk4
uQV53/LuY68m5dd6/BP1jZH8GsRMipmCS+REKfWSuVfoX9On1TsZB7pEtuGFwXVS
T7aSk8iuCek=
=uFME
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
