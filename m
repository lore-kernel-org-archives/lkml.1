Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZDTKgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZDTKgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 06:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZDTKgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 06:36:38 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:33499 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZDTKgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 06:36:37 -0400
Date: Mon, 20 Apr 2009 12:36:36 +0200
From: Nico Schottelius <nico-linux-20090213@schottelius.org>
To: Nico Schottelius <nico-linux-20090213@schottelius.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
       Matthew Garrett <mjg@redhat.com>
Subject: Re: [Bug #12705] X200: Brightness broken since
	2.6.29-rc4-58-g4c098bc
Message-ID: <20090420103636.GA6611@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090213@schottelius.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Dave Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
	Matthew Garrett <mjg@redhat.com>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <AsKNxFx2juN.A.vfB.lHn2JB@chimera> <alpine.LFD.2.00.0904070011280.5698@localhost.localdomain> <200904072316.15367.rjw@sisk.pl> <20090417143532.GA6195@ikn.schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20090417143532.GA6195@ikn.schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc2-next-20090420 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Nico Schottelius [Fri, Apr 17, 2009 at 04:35:32PM +0200]:
> Brightness is *AGAIN* broken in 2.6.30-rc2-00195-g9f76208.

2.6.30-rc2-next-20090420:

My display *is* at full brightness, but I cannot adjust it,
because I'm missing some files:

[12:35] ikn:~# ls /sys/class/video_output=20
[12:35] ikn:~# ls /sys/class/backlight  =20
[12:35] ikn:~# ls /proc/acpi          =20
ac_adapter  debug_layer  embedded_controller  fan   power_resource  thermal=
_zone
battery     debug_level  event          ibm   processor     wakeup
button      dsdt   fadt         info  sleep

So I cannot adjust brightness. I saw that
/proc/acpi/video/VID/LCD0/brightness was not existing on 2.6.30-rc2-00195-g=
9f76208
either.

Bug or am I missing some new file location?

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknsUDMACgkQuL75KpiFGIyf0gCfb25Zb3ZfQKGgVSpSOGn7dPjg
HqIAoKKn6xKkP/vpFgfYD31BSIxn8fxa
=gITJ
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
