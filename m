Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbXEUA6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbXEUA6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 20:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbXEUA6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 20:58:33 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:54540 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbXEUA6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 20:58:32 -0400
Date: Mon, 21 May 2007 02:58:22 +0200
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 4/8] Force detect and enable HPET on ICH
Message-ID: <20070521025822.506c3287@laptop.hypervisor.org>
In-Reply-To: <20070507203128.GD3926@linux-os.sc.intel.com>
References: <20070507203128.GD3926@linux-os.sc.intel.com>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_.0.LnQYG3B6kZ5A95iGVi=i";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_.0.LnQYG3B6kZ5A95iGVi=i
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 7 May 2007 13:31:28 -0700 Venki Pallipadi (VP) wrote:

VP> Force detect and/or enable HPET on ICH chipsets. This patch just handle=
s the
VP> detection part and following patches use this information.
VP>=20
VP> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Venki,

Is there any reason your patch only enables HPET on ICH6 and beyond? HPET c=
an
be enabled on earlier ICH by setting bit 17 in GEN_CNTL on PCI dev 31, func=
 0,
offset d0. This seems to work for ICH3/4/5. Are there any errata affecting
these ICHs?

Cheers,

	- Udo

--=20
Dipl.-Inf. Udo Steinberg                    =20
Technische Universit=E4t Dresden               http://os.inf.tu-dresden.de/=
~us15
Institute for System Architecture            Tel: +49 351 463 38401
D-01062 Dresden                              Fax: +49 351 463 38284

--Sig_.0.LnQYG3B6kZ5A95iGVi=i
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGUO6unhRzXSM7nSkRAnrcAJ9ie72JPZE7EWI7iGrr1FYQsXhmUgCeJtE+
a4baNlVHmoTLPcg/G2QOFeg=
=JUtU
-----END PGP SIGNATURE-----

--Sig_.0.LnQYG3B6kZ5A95iGVi=i--
