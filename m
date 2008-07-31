Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYGaVNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYGaVNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYGaVNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:13:11 -0400
Received: from mx2.schottelius.org ([62.65.138.77]:34719 "EHLO
	mx2.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYGaVNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:13:10 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2008 17:13:09 EDT
Date: Thu, 31 Jul 2008 23:05:07 +0200
From: Nico Schottelius 
	<nico-linux-kernel-bugreport20080731@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Heavy suspend and io problems in 2.6.27-rc1-00156-g94ad374
Message-ID: <20080731210507.GA6094@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-kernel-bugreport20080731@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: denkbrett (Linux 2.6.26-next-20080725-denkbrett x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello=A1

I've some serious problems with this kernel on the ibm t60:

- wake up from suspend takes about 30 seconds
- i need to switch to console and back to see xorg screen again (before:
  only black)
- after wake up, I get disk input/output errors, no access to sda is
  possible

As I could not do any dumps I took photos of the dmesg output with my
camera and put them in high resolution to

   http://home.schottelius.org/~nico/unix/linux/kernel/2.6.27-rc1-00156-g94=
ad374/

Sincerly,

Nico

ps: please cc me on reply

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiSKQMACgkQuL75KpiFGIxejACePzJ4K0s69eqz7/HD985yoqwN
/gQAoOq0k9q80/vYCWs+OAO4THbHRC2Y
=CzRa
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
