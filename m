Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746Ab0ASBnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0ASBnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 20:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488Ab0ASBnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 20:43:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48933 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab0ASBnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 20:43:07 -0500
Date: Tue, 19 Jan 2010 12:42:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gleb Natapov <gleb@redhat.com>, Vadim Rozenfeld <vrozenfe@redhat.com>
Subject: linux-next: kvm tree build failure
Message-Id: <20100119124259.e0d77b47.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Jan_2010_12_42_59_+1100_H0TUy7yTDbs5uB3/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Jan_2010_12_42_59_+1100_H0TUy7yTDbs5uB3/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Avi,

Today's linux-next build (x86_64 allmodconfig) failed like this:

usr/include/asm/kvm_para.h:5: included file 'asm-x86/hyperv.h' is not expor=
ted

Caused by commit 328aca1e523bedc49592bbdd65bedaa690b8df29 ("KVM:
Implement bare minimum of HYPER-V MSRs").

I have used the kvm tree from next-20100118 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__19_Jan_2010_12_42_59_+1100_H0TUy7yTDbs5uB3/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktVDiMACgkQjjKRsyhoI8wKZgCcDCyYSFyqxhF6xyIjW1GWbHVQ
jH4An2kd/tk8k3Ufl2JklMV9KTeNnP84
=o7Ol
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Jan_2010_12_42_59_+1100_H0TUy7yTDbs5uB3/--
