Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbZBIJf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbZBIJf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbZBIJfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:35:12 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:46131 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbZBIJfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:35:10 -0500
Date: Mon, 9 Feb 2009 10:35:07 +0100
From: Nico Schottelius <nico-linux-20090209@schottelius.org>
To: Linux Next Mailing List <linux-next@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, ipw3945-devel@lists.sourceforge.net
Subject: X200: Suspend & resume, iwlwifi on 2.6.29-rc3-00697-gae1a25d
Message-ID: <20090209093507.GA27678@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090209@schottelius.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc3-ikn-00697-gae1a25d x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

Using latest git fetch from
  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
I can suspend and resume!
(-next: does not work for a long time -- what's happening there?)

Though, the first resume takes about 30 seconds, the following ones
resume within 10 seconds.

The iwlagn / iwlwifi driver does not work anymore: ip l s wlan0 up
makes ip hang for about 10 seconds, issuing the following in dmesg:

[22640.752121] iwlagn: Could not load the INST uCode section
[22640.752132] iwlagn: Unable to set up bootstrap uCode: -110
[22645.752062] iwlagn: Could not load the INST uCode section
[22645.752072] iwlagn: Unable to set up bootstrap uCode: -110
[22650.752118] iwlagn: Could not load the INST uCode section
[22650.752128] iwlagn: Unable to set up bootstrap uCode: -110
[22660.752059] iwlagn: Could not load the INST uCode section
[22660.752069] iwlagn: Unable to set up bootstrap uCode: -110
[22660.761456] iwlagn: Unable to initialize device after 5 attempts.
[22660.761581] iwlagn 0000:03:00.0: PCI INT A disabled

I'm using latest microcode:

[10:33] ikn:~# sha1sum /lib/firmware/iwlwifi-5000-1.ucode ~nico/Desktop/iwl=
wifi-5000-ucode-5.4.A.11/iwlwifi-5000-1.ucode      =20
f06ff86c8baa8616de584f8b0fff072a9aab6a44  /lib/firmware/iwlwifi-5000-1.ucode
f06ff86c8baa8616de584f8b0fff072a9aab6a44  /home/user/nico/Desktop/iwlwifi-5=
000-ucode-5.4.A.11/iwlwifi-5000-1.ucode

I'm wondering what's broken with iwlwifi and why the first resume takes so =
long.
Anyone a good idea?

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmP+MsACgkQuL75KpiFGIwPaQCeIhlO31jzPFnVxSlUxtXOeV1t
cVMAn3lJOyaznNx4ZwDj3ExPFStWUzW2
=qvgu
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
