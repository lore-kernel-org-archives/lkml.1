Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbZLWWTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbZLWWTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 17:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756979AbZLWWTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 17:19:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48424 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853AbZLWWTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 17:19:13 -0500
Date: Thu, 24 Dec 2009 09:19:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>,
       H Hartley Sweeten <hartleys@visionengravers.com>
Subject: linux-next: manual merge of the watchdog tree with the  tree
Message-Id: <20091224091904.72ef2708.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Dec_2009_09_19_04_+1100_Ch9YSD0ZnnQ5EOWs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Dec_2009_09_19_04_+1100_Ch9YSD0ZnnQ5EOWs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

Today's linux-next merge of the watchdog tree got a conflict in
drivers/watchdog/rm9k_wdt.c between commit
de4148f3ef54b644a181ad75a6fb4b373f2b01f0 ("MIPS: eXcite: Remove
platform") from Linus' tree and commit
f277223000a651df741e2e3367b498049139298d ("[WATCHDOG] use resource_size
()") from the watchdog tree.

The former commit removes the file changed by the latter.  I just removed
the file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Dec_2009_09_19_04_+1100_Ch9YSD0ZnnQ5EOWs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksyl1gACgkQjjKRsyhoI8yAzACcDJiGwvIJZYleudZnUbVi8ib+
gUYAoJOO+S63SYwkw7O402VK4yViOFWY
=H7uV
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Dec_2009_09_19_04_+1100_Ch9YSD0ZnnQ5EOWs--
