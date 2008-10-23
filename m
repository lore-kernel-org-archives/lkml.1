Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbYJWVcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbYJWVcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYJWVbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:31:45 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:57102 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYJWVbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:31:44 -0400
Date: Thu, 23 Oct 2008 23:07:07 +0200
From: Nico Schottelius <nico-linux-next@schottelius.org>
To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Current suspend issues on Lenovo X200
Message-ID: <20081023210707.GA5089@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-next@schottelius.org>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20081023204326.GB4175@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20081023204326.GB4175@denkbrett.schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.27-next-20081023-denkbrett x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

First of all, this was wrong:

Nico -telmich- Schottelius [Thu, Oct 23, 2008 at 10:43:26PM +0200]:
>  - 2.6.27: system freeze instead of wakeup
>    -> shows parts of the X screen, but does not react on ping

System does not freeze, but reboots instead.

Tried next-20081023 and 2.6.27 with acpi_sleep=s3_bios:

- suspend and wakeup on console works fine for both!
- no X running on next
- 2.6.27 + X -> reboot on wakeup

Nico

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkA53sACgkQuL75KpiFGIzsYwCg1Aau0azNz0RY7IAYKjJXox6b
kXQAni+hito4Aan49XHcbRfcEm1xfB9b
=ePu0
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
