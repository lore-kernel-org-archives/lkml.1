Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065Ab0ATGsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0ATGsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597Ab0ATGsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:48:23 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44878 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab0ATGsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:48:21 -0500
Date: Wed, 20 Jan 2010 17:48:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>, ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: kvm tree build warning
Message-Id: <20100120174814.43195995.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jan_2010_17_48_14_+1100_/UdAP83nse0eUvCL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jan_2010_17_48_14_+1100_/UdAP83nse0eUvCL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Not sure what happened to the previous versions To/CC lists, sorry]

Hi all,

Today's linux-next build (powerpc allyesconfig) produced this warning:

arch/powerpc/kvm/book3s.c: In function '__kvmppc_vcpu_run':
arch/powerpc/kvm/book3s.c:1102: warning: 'ext_bkp.vrsave' may be used unini=
tialized in this function

Introduced by commit 2609c1d06b6a7952273fb33b33ad32aff0628146 ("KVM: PPC:
Add support for FPU/Altivec/VSX").  This *may* be a false positive but
will be a problem for normal builds where warnings are treated as errors
in arch/powerpc.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jan_2010_17_48_14_+1100_/UdAP83nse0eUvCL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktWpy4ACgkQjjKRsyhoI8zjWgCdGZ+91dcQ9xNwHclINlXj1yGJ
XZ8An0667fIZEh1KcWj4k/YlsLpLeoAa
=42oX
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jan_2010_17_48_14_+1100_/UdAP83nse0eUvCL--
