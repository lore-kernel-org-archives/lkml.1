Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbYDCXIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYDCXIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYDCXIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:08:36 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54458 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044AbYDCXIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:08:35 -0400
X-Sasl-enc: kOh36WWQsu2At6maqPlsrw/YmhMzT38vstwRlpR7lux3 1207264113
Message-ID: <47F56363.4090002@imap.cc>
Date: Fri, 04 Apr 2008 01:08:19 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 2.6.25-rc8-mm1: Intel SATA boot failure
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
In-Reply-To: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig32A17F2F33F1E2B20B399749"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig32A17F2F33F1E2B20B399749
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andrew Morton schrieb:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc=
8/2.6.25-rc8-mm1/

This fails to come up on my development machine, apparently because it
has trouble accessing the SATA hard disks.
Hardware: Intel Pentium D940, Intel DQ965GF board, two SATA hard disks.
Some unusual things I noticed during the boot process:

- a message "doing fast boot" that looked unfamiliar; unfortunately
  it scrolled off too quickly to note its context

- for each of the two SATA ports in use, a message
  "SATA port is slow to respond, please be patient"
  accompanied by about 10 secs wait

- it actually got past the point where it mounts the root file system,
  so it must have thought it could access the disks

- finally, the system hung completely after the SUSE startup messages

  Setting current sysctl status from /etc/sysctl.conf
  net.ipv4.icmp_echo_ignore_broadcasts =3D 1

  with a dead keyboard and I had to hit the Win^Wreset button.

- After rebooting into 2.6.24-rc8 (which works fine), nothing had been
  written to the disks, not even the dmesg output which SUSE usually
  dumps into /var/log/boot.msg early during startup.

Before I try booting that kernel again, any instructions on what to
watch out for? Is netconsole usable again? Other ideas?

Regards,
Tilman


--------------enig32A17F2F33F1E2B20B399749
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFH9WNuQ3+did9BuFsRArtwAJ9oDWistx1H0H5+6+H1dQcpVWdidwCdHboc
KkAIEyX9FxnAqcH5NayPaOY=
=EgLX
-----END PGP SIGNATURE-----

--------------enig32A17F2F33F1E2B20B399749--
