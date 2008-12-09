Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbYLIIxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbYLIIxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 03:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYLIIxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 03:53:35 -0500
Received: from RedStar.dorchain.net ([212.88.133.153]:44192 "EHLO
	Redstar.dorchain.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbYLIIxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 03:53:33 -0500
X-Greylist: delayed 1340 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 03:53:32 EST
X-DKIM: Sendmail DKIM Filter v2.6.0 Redstar.dorchain.net mB98Q9fE010876
Date: Tue, 9 Dec 2008 09:26:08 +0100
From: Joerg Dorchain <joerg@dorchain.net>
To: Andreas Bombe <aeb@debian.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amiflop: get rid of sleep_on calls
Message-ID: <20081209082608.GA10651@Redstar.dorchain.net>
References: <1228755578-26069-1-git-send-email-aeb@debian.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <1228755578-26069-1-git-send-email-aeb@debian.org>
X-message-flag: Formating hard disk. please wait...   10%...  20%...
X-Bindford: 6200 (more Power!)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 08, 2008 at 04:59:38PM +0000, Andreas Bombe wrote:
> The replacement for the unconditional sleep_on() in fd_motor_on() is a
> complete_all() together with a INIT_COMPLETION() before the mod_timer()
> call.  It appears to me that fd_motor_on() might be called concurrently
> and fd_select() does not guarantee mutual exclusivity in the case the
> same drive gets selected again.

Selecting the same drive repeatly does not matter. The selected
drive is the one the next command or transfer applies to.

It is possible to select one drive, start the motor, select the
next one, start the motor, as long as as trasnfer is tried until
the drive is up to speed (either by signal or the timeout)

At first glance, the patch looks ok.

Bye,

Joerg

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk+K6AACgkQjY4+4PdzvOAInQCeMimYOg9/ZFRn12nvlSWMcEp+
IA0AoIOMiGFlazwfBeE1iOpdDjNgGmGG
=BNAn
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
