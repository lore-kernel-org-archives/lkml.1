Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbYKNPLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbYKNPLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 10:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYKNPLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 10:11:46 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:50217 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYKNPLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 10:11:45 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2008 10:11:45 EST
Date: Fri, 14 Nov 2008 16:05:08 +0100
From: Nico -telmich- Schottelius 
	<nico-linux-iwlwifi5100@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: yi.zhu@intel.com, nico-linux-iwlwifi5100@schottelius.org
Subject: 2.6.28-rc4: iwlagn / 5100 state
Message-ID: <20081114150508.GC4877@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-iwlwifi5100@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.28-rc4-denkbrett x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

Using that kernel I see the following features / bugs:

   - loading the firmware "freezes" the system for a few seconds
   - setting the link up of wlan0 "freezes" the system for a few seconds
   - connecting to 802.11b/g works (802.11a is untested)
   - roaming does *NOT* work -> just looses the AP, does not connect
     to other AP with same essid
   - connecting to a ap sometimes does not work, though essid is set
      -> sometimes it helps to specify "ap <addr>"
      -> sometimes setting down and up the link helps
      -> with earlier kernels one sometimes needed to rmmod and insmod
         the module again, so there is some progress :-)

So far it is somehow usable, though the connection problems and missing
roaming is a bit painful.

Sincerly,

Nico


--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkdk6QACgkQuL75KpiFGIxcHQCg4XQamZ4/xWXoQGyQwX9AzwJL
VWUAoIn73kLbSqjNjR/6AyUHvzpE5/qD
=HvEk
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
