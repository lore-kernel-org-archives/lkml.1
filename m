Return-Path: <linux-kernel-owner+w=401wt.eu-S1759142AbZCYQ6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142AbZCYQ6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZCYQ6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:58:42 -0400
Received: from clausfischer.com ([78.46.66.52]:48519 "EHLO clausfischer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbZCYQ6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:58:41 -0400
X-Greylist: delayed 1433 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Mar 2009 12:58:40 EDT
Date: Wed, 25 Mar 2009 17:34:41 +0100
From: Claus Fischer <claus.fischer@clausfischer.com>
To: linux-kernel@vger.kernel.org
Subject: Irritating USB Flash Memory LED behaviour (usb_storage related?)
Message-ID: <20090325163441.GA17166@clausfischer.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Summary: Some new USB memory sticks will not stop blinking the LED.
         Behaviour varies across distributions and OS's.
         Any helpful hints appreciated.


On a system that we use for mass erasure of USB sticks (64 sticks),
based on Debian with automatical udev-handling of USB sticks disabled,
we have a problem with a batch of new USB sticks: They will continue
blinking for as long as they are plugged in, independent of data
access.

The sticks however stop blinking (as they should) on a SuSE based
desktop system with the usual KDE software. They also stop blinking
when attached to a Windows system.


Good behaviour:
***************

Previously, (good) USB sticks would behave like this:
 -  blink while the usb_storage module identifies them
    and maps them to an SCSI device
 -  then stop blinking
 -  blink again while being formatted via our script
 -  stop blinking after being unmounted
Together with a visual program display, the blinking LED has always
been a good indicator for operating personnel of the stick's status.

Bad behaviour:
**************
The new sticks will start blinking when the usb_storage module kicks
in use, and continue blinking throughout idle phases, mounts, writes,
umounts etc.; an eject command will change the blinking to
a permanently lighted LED, but it will never go off.




I'm at a loss looking for the reason of the continued blinking,
and how to get rid of it (it's a large batch of sticks, and
returning them is out of the question).

Possible causes:
 - Kernel
   But: the "good" SuSE kernel 2.6.25 is between "bad" Debian 2.6.16
   and "bad" Debian 2.6.26.
   Also, old USB sticks work fine with each machine.
 - Bad USB controller
   The new batch of sticks uses a different internal USB
   controller from old batches.
   But: Windows and SuSE work fine.
 - Interaction of KDE components with the USB stick
   that is missing on our batch formatting system.
   But: Why do old sticks work fine without such interaction?


Questions:
 - I always thought that USB stick LEDs cannot be controlled by the
   operating system. They just indicates "write accesses".
   Is that correct?
 - If USB stick leds are not OS-accessible, why do the new
   sticks behave differently on different systems?
 - If USB stick leds are OS-accessible, has there been any change
   in policy of kernel/modules that leave them blinking?
 - Can anyone point me to information how SuSE/KDE control the
   blinking light, and how I can (write code to) let the LED
   react similarly on our Debian-based batch system?
   [ For various reasons beyond the scope of this mail,
     automatically mounting the sticks is out of the question. ]


Any helpful hints, pointers to knowledge/information etc. are
greatly appreciated.

Best regards,

Claus


--=20
Claus Fischer <claus.fischer@clausfischer.com>
http://www.clausfischer.com/

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJyl0hm6yxRhwvRIsRAp94AJ0QRQC/dxUigkz1Rbipe5hTjdKykwCeKXcG
4Ou1yHq0l4E0N0YIIye2GjU=
=SPJu
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
