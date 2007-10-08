Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbXJHCyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbXJHCyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 22:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbXJHCyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 22:54:11 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41245 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbXJHCyK (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 22:54:10 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm[12] - the amazing disappearing MSI IRQ
In-Reply-To: Your message of "Sun, 07 Oct 2007 00:51:32 EDT."
             <23735.1191732692@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <23735.1191732692@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1191812048_12267P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 07 Oct 2007 22:54:08 -0400
Message-ID: <13221.1191812048@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1191812048_12267P
Content-Type: text/plain; charset=us-ascii

On Sun, 07 Oct 2007 00:51:32 EDT, Valdis.Kletnieks@vt.edu said:
> I've also seen the eth0 MSI IRQ evaporate, leaving *two* 'none-edge' IRQs,
> but I can't replicate it at the moment, as it seems to happen pseudo-randomly.

Ignore this part - the problem is confined to the HDA-Intel driver.

I've verified the eth0 was a red herring - what would happen is if I booted
it while undocked, the startup scripts would try to ifconfig it up, find no
link on the device, and then ifconfig it down, at which point /proc/interrupts
would show it as 'none-edge' because at one time there *had* been interrupts
on it when it was 'PCI-MSI-edge', but it was then turned off again.

--==_Exmh_1191812048_12267P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHCZvQcC3lWbTT17ARAoK6AKDY8IHkQQZzDPX+3VPKU9zA/hdACgCeNiHt
tOy4oR3hv846PNw+YrZXb/w=
=+oVG
-----END PGP SIGNATURE-----

--==_Exmh_1191812048_12267P--
