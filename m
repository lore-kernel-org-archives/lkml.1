Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbZIAC57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbZIAC57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 22:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZIAC56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 22:57:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36989 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbZIAC55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 22:57:57 -0400
Date: Tue, 1 Sep 2009 12:57:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>
Subject: linux-next: acpi tree build failure
Message-Id: <20090901125748.fb33b2ea.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Sep_2009_12_57_48_+1000_1hmTRUJT0WWTHGxn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Sep_2009_12_57_48_+1000_1hmTRUJT0WWTHGxn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/acpi/als.c: In function 'acpi_als_get_mappings':
drivers/acpi/als.c:173: error: expected ')' before 'PREFIX'
drivers/acpi/als.c: In function 'acpi_als_add':
drivers/acpi/als.c:347: error: expected ')' before 'PREFIX'

I have used the version of the acpi tree from next-20090831 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Sep_2009_12_57_48_+1000_1hmTRUJT0WWTHGxn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqcjawACgkQjjKRsyhoI8zBQACgo46m8eVRyIlmkLJ5JYfbQB9T
BCMAn0HJo1Yv5ZVg0qy3SCWmG80z5lpk
=qtgq
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Sep_2009_12_57_48_+1000_1hmTRUJT0WWTHGxn--
