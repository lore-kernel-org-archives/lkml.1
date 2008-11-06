Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbYKFPua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbYKFPua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYKFPuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:50:11 -0500
Received: from gold.linx.net ([195.66.232.40]:58864 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbYKFPuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:50:09 -0500
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2008 10:50:09 EST
Subject: Re: Long delays and keystrokes required - related to
	disk	encryption?
From: Tony Vroon <tony@linx.net>
Reply-To: tony@linx.net
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Bernhard Schmidt <berni@birkenwald.de>,
       Yves-Alexis Perez <corsac@debian.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, "Carlos R. Mafra" <crmafra2@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4911B829.8040701@linux.intel.com>
References: <20081105020340.GA6399@schleppi.birkenwald.de>
	 <4911B829.8040701@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OCuy3a7WEMGUlvEIre+B"
Organization: London Internet Exchange (LINX; AS5459)
Date: Thu, 06 Nov 2008 15:41:03 +0000
Message-Id: <1225986063.4234.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OCuy3a7WEMGUlvEIre+B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 07:13 -0800, Arjan van de Ven wrote:
> I assume that if you add that return it also works?
> (if not you have a totally unrelated issue)

Another report of the same problem.
Yes, adding a return there fixes everything.

> one request to the folks on the mail who know it's fixed by the return;
> can you send me your .config and dmesg and name of the machine?
> (eg vendor/model)

I have seen this on two of our laptop types so far:
Fujitsu-Siemens Lifebook E8410 (BIOS 1.30)
ICH8M-based Centrino

Fujitsu-Siemens Lifebook E8420 (BIOS 1.14)
ICH9M-based Centrino2

> I'm failing to reproduce and would like to get as exactly the same as you=
 guys as possible...

As an observation, things seem to slow down as the init process in
initramfs is loaded. First I thought it was waiting for user input in
the initramfs that slowed down, but it turned out I needed to hit Ctrl
once to get to even get to the input prompt.
Enabling an initramfs and sticking a simple script in there may suffice.
All machines affected appear to be recent (ICH7/8/9) Centrino laptops
with HPET enabled, if that helps.

Whatever goes wrong that early in boot intermittently manifests as long
as the system is running, and seems to interfere with HD Audio here (I
get spurious timeouts, first the driver switches to polling mode and I
lose unsollicited event support entirely, then it switches into single
command mode and I lose all audio functionality)

Regards,
Tony V.

--=-OCuy3a7WEMGUlvEIre+B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkkTEA8ACgkQp5vW4rUFj5qC4ACfVC2eMjxih8Wau4WaZSDarKSU
v/AAoIgBx18DP2TbL/NAo3dTAh4cqRAn
=WtZe
-----END PGP SIGNATURE-----

--=-OCuy3a7WEMGUlvEIre+B--

