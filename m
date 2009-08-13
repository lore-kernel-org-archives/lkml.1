Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbZHMC6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbZHMC6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 22:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZHMC6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 22:58:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59222 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbZHMC6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 22:58:46 -0400
Date: Thu, 13 Aug 2009 12:58:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: kvm tree build failure
Message-Id: <20090813125840.048af293.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_Aug_2009_12_58_40_+1000_K.H+UJW_RLzvL7Ab"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Aug_2009_12_58_40_+1000_K.H+UJW_RLzvL7Ab
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Avi,

Today's linux-next build (x86_64 allmodconfig) failed like this:

x86_64-linux-gcc: arch/x86/kvm/x86_emulate.c: No such file or directory

Caused by commit 5383e9982ee230b06b3c385e675ae6fc7846c40f ("KVM: Rename
x86_emulate.c to emulate.c").

I have used the version of the kvm tree from next-20090812 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_Aug_2009_12_58_40_+1000_K.H+UJW_RLzvL7Ab
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqDgWAACgkQjjKRsyhoI8wBwwCcCLpWhhdhFpw3xCw0C9L4mezt
57AAnAyJFp5uRQVQ8xEz9PAAREi9wTt1
=L+1u
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Aug_2009_12_58_40_+1000_K.H+UJW_RLzvL7Ab--
