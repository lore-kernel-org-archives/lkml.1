Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbZBQRCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbZBQRCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZBQRBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:01:53 -0500
Received: from mx34.mail.ru ([94.100.176.48]:7752 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbZBQRBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:01:52 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net
Subject: 2.6.29 regression? Bonding tied to IPV6 in 29-rc5
Date: Tue, 17 Feb 2009 20:01:38 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-1avb; KDE/4.2.0; i686; ; )
Cc: "J.A. =?iso-8859-1?q?Magall=F3n?=" <jamagallon@ono.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0902131413120.3179@localhost.localdomain> <20090217095232.5da06b9f@werewolf.home>
In-Reply-To: <20090217095232.5da06b9f@werewolf.home>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1637276.dJUPc8l8uO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200902172001.41804.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1637276.dJUPc8l8uO
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=46orward to bonding and netdev

On 17 of February 2009 11:52:32 J.A. Magall=F3n wrote:
> Hi all...
>
> Don't know if this is specific for -rc5, I have jumped from 28.4 to
> 29-rc5. In this latest kernel, I can not install 'bonding' module if
> 'ipv6' is disabled to load via modprobe.conf:
>
> install ipv6 /bin/true
>
> Trying bonding gives this dmesg:
>
> bonding: Unknown symbol ndisc_build_skb
> bonding: Unknown symbol in6_dev_finish_destroy
> bonding: Unknown symbol ndisc_send_skb
> bonding: Unknown symbol unregister_inet6addr_notifier
> bonding: Unknown symbol register_inet6addr_notifier
>
> Commenting the line in modprobe.conf makes things smooth again.
> We can not disable ipv6 anymore ?
>

If IPv6 is disable in kernel config bonding loads. But I think it is=20
regression, it should be possible to disable IPv6 if not required.

--nextPart1637276.dJUPc8l8uO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkma7XUACgkQR6LMutpd94yslQCgr24HkjZ2/b6tdSdNyRDd0O+v
TscAoJRRRG0sEQrm3ah7ckShoE5VI2gZ
=D46+
-----END PGP SIGNATURE-----

--nextPart1637276.dJUPc8l8uO--
