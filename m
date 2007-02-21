Return-Path: <linux-kernel-owner+w=401wt.eu-S1030298AbXBUOXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030298AbXBUOXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 09:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030353AbXBUOXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 09:23:33 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:57911 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030298AbXBUOXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 09:23:32 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] EXPORT_SYMBOL() time functions
Date: Wed, 21 Feb 2007 15:23:47 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
References: <200702211412.23388.eike-kernel@sf-tec.de> <1172064736.3531.191.camel@laptopd505.fenrus.org>
In-Reply-To: <1172064736.3531.191.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2270784.UVpErG31RG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702211523.54198.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2270784.UVpErG31RG
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Arjan van de Ven wrote:
> On Wed, 2007-02-21 at 14:12 +0100, Rolf Eike Beer wrote:
> > These functions were inlines before
> > 8b9365d753d9870bb6451504c13570b81923228f. Now EXPORT_SYMBOL() them to
> > allow them to be used in modules again.
>
> please do not add random exports without users; exports eat up kernel
> size and memory. At minimum specify which mainline modules use the
> exports..

Nothing in mainline now. I just found out that the module I'm writing doesn=
't=20
work anymore as timeval_to_jiffies() disappeared. If this is planned to go=
=20
away from modules I should consider switching to timespec.

Eike

--nextPart2270784.UVpErG31RG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBF3FX6XKSJPmm5/E4RAtSRAJwPfWRKu5dYPn3EitRMSxjRNNif9QCgoXjk
tCPQ7gVsgtA5ZPA3DSfsuZA=
=lIht
-----END PGP SIGNATURE-----

--nextPart2270784.UVpErG31RG--
