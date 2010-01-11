Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606Ab0AKIZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0AKIZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 03:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587Ab0AKIZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 03:25:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37776 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab0AKIZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 03:25:13 -0500
Date: Mon, 11 Jan 2010 19:25:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>
Subject: linux-next: kvm tree build warning
Message-Id: <20100111192508.d98b1c2b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__11_Jan_2010_19_25_08_+1100_u7fLP1zzrbtuzL2b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Jan_2010_19_25_08_+1100_u7fLP1zzrbtuzL2b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Avi,

Today's linux-next build (powerpc allyesconfig) produced this warning:

arch/powerpc/kvm/powerpc.c: In function 'kvm_arch_vcpu_ioctl_run':
arch/powerpc/kvm/powerpc.c:278: warning: 'gpr' may be used uninitialized in=
 this function

Yes, I know it is probably a false positive.

Introduced by commit 7f31fad9aad3bb9df95793d72e037bb4d587ee83 ("KVM: PPC:
Use accessor functions for GPR access").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__11_Jan_2010_19_25_08_+1100_u7fLP1zzrbtuzL2b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktK4GQACgkQjjKRsyhoI8yJJQCgrH8CfDAN+kQjSMpC/8XPsXwU
Fv0AoJujyY5vFiKCoHROSkIOPyCjuDoE
=mwN/
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Jan_2010_19_25_08_+1100_u7fLP1zzrbtuzL2b--
