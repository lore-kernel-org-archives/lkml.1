Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZFRBLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZFRBLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 21:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZFRBL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 21:11:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58370 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbZFRBL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 21:11:26 -0400
Date: Thu, 18 Jun 2009 11:11:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: linux-next: kvm tree build failure
Message-Id: <20090618111120.9c226ab7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__18_Jun_2009_11_11_20_+1000_.b_jVDOvifQx06zF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Jun_2009_11_11_20_+1000_.b_jVDOvifQx06zF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Avi,

Today's linux-next build (x86_64 allmodconfig) failed like this:

arch/x86/kvm/svm.c: In function 'svm_set_msr':
arch/x86/kvm/svm.c:2152: error: 'MSR_K8_HWCR' undeclared (first use in this=
 function)

Caused by commit 6878bf85dfc107cea4660f1167693c15754c1660 ("KVM:
Implement MSRs used by Hyper-V").  MSR_K8_HWCR was removed by commit
bf8b9a63c18a1a7777571650de0c9f4fd4368ca0 ("x86: msr-index.h remove
duplicate MSR C001_0015 declaration") which is now in Linus' tree (it
entered Linus' tree on Jun 10 via commit
7dc3ca39cb1e22eedbf1207ff9ac7bf682fc0f6d "Merge branch
'x86-cleanups-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip").

I have used the version of the kvm tree from 20090617.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__18_Jun_2009_11_11_20_+1000_.b_jVDOvifQx06zF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko5lDgACgkQjjKRsyhoI8xRKwCfTipW++UBrNRwLrTiANUOD4ku
YucAn3zGTvkK+30TofN6EpKurgkWY4kt
=r30b
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Jun_2009_11_11_20_+1000_.b_jVDOvifQx06zF--
