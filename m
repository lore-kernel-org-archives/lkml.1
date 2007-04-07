Return-Path: <linux-kernel-owner+w=401wt.eu-S964791AbXDGAxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbXDGAxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 20:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964806AbXDGAxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 20:53:35 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:51400 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964791AbXDGAxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 20:53:33 -0400
Date: Sat, 7 Apr 2007 01:53:31 +0100
To: linux-kernel@vger.kernel.org
Subject: Hanging on activating cpufreq
Message-ID: <20070407005331.GD13699@amphibian.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Matthew Toseland <toad@amphibian.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linux hangs when powernow-k8 attempts to change the clock speed. Happens
on 2.6.21-rc6, -rc5 and (at least) back to 2.6.18. The hang occurs before
loading X and so is in text mode. alt+sysrq+z/b/etc doesn't work, nor
does the NMI watchdog despite its being loaded ("Testing NMI watchdog ...
OK."). However, the hangcheck option *does* work (reboots it a few
seconds after it hangs). Another interesting point is that this
motherboard (asus M2V, via K8T890 based) worked until yesterday with a
different CPU. But since hangcheck works, the CPU must still be active.
I have been through the relevant BIOS settings, and googled extensively.

Any hints as to how to debug this further, or whether it is likely to be
worthwhile to do so?

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGFuuLA9rUluQ9pFARApUgAKCS+cJGgFVfaeGfGwHaleX462SOGgCgjxG7
3Q1bvD3g1KtP5bMuof0uX30=
=xOLC
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--

