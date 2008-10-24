Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbYJXQYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbYJXQYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 12:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYJXQYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 12:24:30 -0400
Received: from ganymede.vroon.org ([195.66.242.11]:41935 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbYJXQYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 12:24:30 -0400
Subject: Re: MCEs
From: Tony Vroon <tony@vroon.org>
To: Felix von Leitner <felix-linuxkernel@fefe.de>
Cc: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20081024124502.GA9425@codeblau.de>
References: <20081024124502.GA9425@codeblau.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-41KTcAxM9lcd/PsL55G+"
Date: Fri, 24 Oct 2008 17:23:18 +0100
Message-Id: <1224865398.9632.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-41KTcAxM9lcd/PsL55G+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-24 at 14:45 +0200, Felix von Leitner wrote:
> Now the most common causes for MCEs are apparently heat issues and bad
> memory.  I can rule out both.

Are you sure? I have had MCEs and instability for a while now, and using
mcelog --k8 --dmi /dev/mcelog

I finally got a clear "this component is at fault" message, pinpointing
DIMM 4 on CPU 2. I shuffled the DIMMs around and then used the machine
again.
The message shifted with the DIMM, to DIMM 1 on CPU 1. Memtest86+
doesn't appear to stress the hardware enough to provoke single or
multi-bit errors though. (So, a few successful passes in memtest86+ does
not rule out a RAM problem)

Temperatures can also get high at locations in the machine that have no
sensors (specifically voltage regulators). To check for heat problems
you could operate your tower case whilst lying on the floor, so hot air
rises up past the PCI/PCIe cards instead of getting trapped underneath
them.

Note that LKML isn't the friendliest place to get MCE debugging, as it
will be considered a hardware fault and thus off-topic.
Consider an MCE like a 'check engine' light in your car. It doesn't tell
you what's wrong, just that it's bad and should be investigated.

Regards,
Tony V.

--=-41KTcAxM9lcd/PsL55G+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkkB9nYACgkQp5vW4rUFj5ravgCeI0v0ui8UXN21LmVr3wsvg/Fy
C5kAnjVoNllbGbMNS27m8oSi4s966dcJ
=Lyef
-----END PGP SIGNATURE-----

--=-41KTcAxM9lcd/PsL55G+--

