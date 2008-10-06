Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYJFRX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYJFRX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYJFRXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:23:18 -0400
Received: from romulus.commandcorp.com ([130.205.32.3]:32836 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbYJFRXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:23:16 -0400
X-Greylist: delayed 678 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2008 13:23:16 EDT
Subject: Fedora 9, IPSec, and 2.6.26 kernels...
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: fedora-list@redhat.com, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: mhw@WittsEnd.com
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qVouPv7JzbNh0I03eb3C"
Organization: Thaumaturgy & Speculums Technology
Date: Mon, 06 Oct 2008 13:10:54 -0400
Message-Id: <1223313054.25404.37.camel@canyon.wittsend.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (romulus.wittsend.com [IPv6:2001:4830:3000:2:280:3fff:fe03:455b]); Mon, 06 Oct 2008 13:11:00 -0400 (EDT)
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner-ID: m96HAx6U023486
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-From: mhw@wittsend.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qVouPv7JzbNh0I03eb3C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey all,

        I just ran into this massive problem this weekend.  Several of
my Fedora 9 systems are linked by IPSec (OpenSWAN) tunnels across three
remote sites.  I recently updated the kernels on them (about a half a
dozen systems) to 2.6.26-45 and each and every system with IPsec
destabilized.  They would run for anywhere from a few minutes to a few
hours and then lock dead up.  No network.  Outside pings on IPv4 and
IPv6 all return "no route to host".  If they had X-Windows running,
no response to keyboard.  Mouse MIGHT work but would also shortly lock
up.  USB locked pretty solid.  No ability to log in.  No user space
activity.  Enabled Magic SysRq key and each machine could be rebooted
via Alt-SysRq S-U-B, so interrupts are functioning and the kernel is
responding to the keyboard on that level even if it's a USB keyboard.
Could not switch from X-Windows to a virtual console and cntrl-alt-del
had no effect.  Set sysctl kernel.panic =3D 5 with no effect so there
doesn't seem to be a kernel panic involved that I can't see on the consoles.

        Backed up to the last 2.6.25 kernel and they are all stable again.
All have now been running, once again, for over 24 hours.  I don't know
the status of any intervening 2.6.26 kernels.  The machines that
destabilized had not been rebooted on a 2.6.26 kernel before.  Other
systems with F9 2.6.26-45 kernels w/o IPSec seem stable.  Restarting
OpenSWAN a few times seems to be a pretty reliable way to lock the
system up with or without X Windows present.

        Anyone else seeing this?  Anyone with an idea what might be
going wrong?

        I have not, as yet, tried as non-Fedora kernel.  Some of my other
systems are running OpenVZ kernels (some with IPsec), currently sitting
at 2.6.24, and are stable.  I'll be trying the OpenVZ 2.6.26 kernel as
soon as it's released later this week.

        BTW...  OpenSWAN 2.6.14, in Fedora 9, is pretty well busted for
X.509 certificates (problems in connection identification for X.509).
Been debugging this with the OpenSWAN dudes for the last week or so and
finally got that resolved when  I ran into this.  OpenSWAN 2.6.18 should
resolve the X.509 certificate issues and some rekeying issues.

        Mike
--=20
Michael H. Warfield (AI4NB) | (770) 985-6132 |  mhw@WittsEnd.com
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0xDF1DD471        | possible worlds.  A pessimist is sure of it!


--=-qVouPv7JzbNh0I03eb3C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQCVAwUASOpGneHJS0bfHdRxAQI9/gP+JMHo2tGRo9ttR0ZiiAqrI07hB1j1ShW1
JH6EhrUolUrSKAmY4XUK6KG0DylQc0gEJg5dlxxI6bNMuU3/6FWTpp12HD98mOgH
IqraFedSYX5ip1/d0yX7o+WF4+2Xbn/MyR0O9jQlNZa1XHcB6iQOKGZv2HgAaKAN
8X+Eyn3G7GI=
=grKN
-----END PGP SIGNATURE-----

--=-qVouPv7JzbNh0I03eb3C--

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.
