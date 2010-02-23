Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab0BWFHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 00:07:55 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48445 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab0BWFHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 00:07:53 -0500
Date: Tue, 23 Feb 2010 16:07:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Luke Yelavich <luke.yelavich@canonical.com>
Subject: linux-next: build warning after merge of the sound tree
Message-Id: <20100223160746.e283a14f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Feb_2010_16_07_46_+1100_H43FxMAjtwTePNut"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Feb_2010_16_07_46_+1100_H43FxMAjtwTePNut
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

After merging the sound tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

sound/pci/hda/patch_realtek.c:7016: warning: 'alc885_macmini3_ch2_init' def=
ined but not used
sound/pci/hda/patch_realtek.c:7028: warning: 'alc885_macmini3_ch6_init' def=
ined but not used

Introduced by commit e458b1fadf9239d1fdb165ff4c4ea0d807041bec ("ALSA: hda
- Add Macmini 3,1 support").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Feb_2010_16_07_46_+1100_H43FxMAjtwTePNut
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuDYqIACgkQjjKRsyhoI8wjrACfUPwwlQwdEXCiTF+UyNsfQuzb
+8AAn1R8mz3PAnx7b1qFrDP2iPhapBYN
=hZ1H
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Feb_2010_16_07_46_+1100_H43FxMAjtwTePNut--
