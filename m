Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZFLI0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZFLI0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760439AbZFLIZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:25:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53708 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbZFLIZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:25:50 -0400
Date: Fri, 12 Jun 2009 18:25:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Sachin Sant <sachinp@in.ibm.com>, linuxppc-dev@ozlabs.org,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PowerPC] 2.6.30-git3 build break : perf counters
Message-Id: <20090612182538.3dc9f7b4.sfr@canb.auug.org.au>
In-Reply-To: <1244788494.5554.1.camel@ht.satnam>
References: <4A31ECCD.7030805@in.ibm.com>
	<1244788494.5554.1.camel@ht.satnam>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Jun_2009_18_25_38_+1000_2cBjL9DO6FyHD9O1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jun_2009_18_25_38_+1000_2cBjL9DO6FyHD9O1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jaswinder,

On Fri, 12 Jun 2009 12:04:54 +0530 Jaswinder Singh Rajput <jaswinder@kernel=
.org> wrote:
>
> Please check this patch :
>=20
> [PATCH] powerpc: perf_counter fix performance counter event types
>=20
> Fix compilation warnings :
>  CC      arch/powerpc/kernel/power7-pmu.o
> arch/powerpc/kernel/power7-pmu.c:297: error: PERF_COUNT_CPU_CYCLES undecl=
ared here (not in a function)
> arch/powerpc/kernel/power7-pmu.c:297: error: array index in initializer n=
ot of integer type
> arch/powerpc/kernel/power7-pmu.c:297: error: (near initialization for pow=
er7_generic_events)
> arch/powerpc/kernel/power7-pmu.c:298: error: PERF_COUNT_INSTRUCTIONS unde=
clared here (not in a function)
> arch/powerpc/kernel/power7-pmu.c:298: error: array index in initializer n=
ot of integer type
> ......<SNIP>......
>=20
> Reported-by: Sachin Sant <sachinp@in.ibm.com>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

I have applied this to linux-next for today.  Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Jun_2009_18_25_38_+1000_2cBjL9DO6FyHD9O1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoyEQIACgkQjjKRsyhoI8xtdwCeINVoUFEPaaoFvD0c2rvkOHq7
jM0An2A4va7j9LZZpRmcfWetiHw/ph0E
=jfms
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jun_2009_18_25_38_+1000_2cBjL9DO6FyHD9O1--
