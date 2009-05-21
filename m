Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbZEUHVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbZEUHVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 03:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbZEUHVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 03:21:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36248 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbZEUHVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 03:21:34 -0400
Date: Thu, 21 May 2009 17:21:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>
Subject: linux-next: kvm tree build failure
Message-Id: <20090521172122.bb12027c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_May_2009_17_21_22_+1000_MEgvJr2jiIFW3JU/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_May_2009_17_21_22_+1000_MEgvJr2jiIFW3JU/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Avi,

Today's linux-next build (powerpc ppc44x_defconfig) failed like this:

arch/powerpc/kvm/built-in.o: In function `kvm_destroy_vm':
kvm_main.c:(.text+0x2cfc): undefined reference to `kvm_irqfd_release'
arch/powerpc/kvm/built-in.o: In function `kvm_vm_ioctl':
kvm_main.c:(.text+0x3230): undefined reference to `kvm_irqfd'

Caused by commit 302471ec2b5b6f74eba06973fb85e4584d20ef1e ("KVM: irqfd")
which I have reverted for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_May_2009_17_21_22_+1000_MEgvJr2jiIFW3JU/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoVAPIACgkQjjKRsyhoI8wtkQCguhOmD0/mA2NysSITpeIwrXhr
4fwAmwWDpnR7gVxd+LghK2MguyNFtYkv
=f3ui
-----END PGP SIGNATURE-----

--Signature=_Thu__21_May_2009_17_21_22_+1000_MEgvJr2jiIFW3JU/--
