Return-Path: <linux-kernel-owner+w=401wt.eu-S1752208AbZINFfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbZINFfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 01:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZINFfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 01:35:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34931 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbZINFfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 01:35:38 -0400
Date: Mon, 14 Sep 2009 15:35:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       <linux-parisc@vger.kernel.org>
Subject: Re: linux-next: manual merge of the security-testing tree with the
 parisc tree
Message-Id: <20090914153532.2c06eeae.sfr@canb.auug.org.au>
In-Reply-To: <20090903154636.e70c50da.sfr@canb.auug.org.au>
References: <20090903154636.e70c50da.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Sep_2009_15_35_32_+1000_A1X+Em1Njn+jEyVK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Sep_2009_15_35_32_+1000_A1X+Em1Njn+jEyVK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kyle,

On Thu, 3 Sep 2009 15:46:36 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the security-testing tree got conflicts in
> arch/parisc/include/asm/thread_info.h, arch/parisc/kernel/entry.S and
> arch/parisc/kernel/signal.c between commit 9f4259771faf1ffd99888796d925ad=
ae4c93630b ("parisc: add TIF_NOTIFY_RESUME and use tracehook_notify_resume"=
) from the parisc tree and
> commits d0420c83f39f79afb82010c2d2cafd150eef651b ("KEYS: Extend
> TIF_NOTIFY_RESUME to (almost) all architectures [try #6]") and
> ee18d64c1f632043a02e6f5ba5e045bb26a5465f ("KEYS: Add a keyctl to install
> a process's session keyring on its parent [try #6]") from the
> security-testing tree.
>=20
> Overlapping changes.  I fixed it up (using the parisc versions and adding
> the extra change from the latter security-testing patch) and can carry
> the fixes as necessary.

This conflict is now between the parisc tree and Linus' tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Sep_2009_15_35_32_+1000_A1X+Em1Njn+jEyVK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqt1iQACgkQjjKRsyhoI8z4xQCdFQ5cNfECXGyQR9dx8LqwGpdN
34sAn35mBi0c2Y1SsuCHuPt5oMvtJGew
=ODSE
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Sep_2009_15_35_32_+1000_A1X+Em1Njn+jEyVK--
