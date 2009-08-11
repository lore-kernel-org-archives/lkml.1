Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbZHKMSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbZHKMSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZHKMSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:18:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42890 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675AbZHKMSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:18:36 -0400
Date: Tue, 11 Aug 2009 13:22:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Clemens Ladisch <clemens@ladisch.de>
Subject: linux-next: sound tree build warning
Message-Id: <20090811132258.8e899735.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__11_Aug_2009_13_22_58_+1000_bCJionCgwSzc=xqC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Aug_2009_13_22_58_+1000_bCJionCgwSzc=xqC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

sound/usb/usbaudio.c: In function 'init_substream_urbs':
sound/usb/usbaudio.c:1087: warning: comparison of distinct pointer types la=
cks a cast

Introduced by commit 765e8db078e63fdc076fcf6024c15d3b7b955746 ("sound:
usb-audio: do not make URBs longer than sync packet interval").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Aug_2009_13_22_58_+1000_bCJionCgwSzc=xqC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqA5BMACgkQjjKRsyhoI8w8egCeKqsPQx5c5z+Ga41Rw43H+LUO
QEYAn2oUxVdWjNhPB9WmE2OH9skM1Vup
=RZ8E
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Aug_2009_13_22_58_+1000_bCJionCgwSzc=xqC--
