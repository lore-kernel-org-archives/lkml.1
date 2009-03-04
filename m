Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbZCDEUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbZCDEUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 23:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZCDEUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 23:20:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:51017 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZCDEUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 23:20:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=K1dj2Z+KwNJ9w1aKQLJ7LpLhbhr5WJO1nwRX7WpWAFWBXAGYsDkOJkCszT8XfosgOO
         4mY1fLocKc2uuBB2cntJ4zmsHgC/GVeN/YWmz11vv3WszGEryb6dpGNzozu+kqJIkHcq
         b8Ge5IWYvmHiZj9+K8m4ECWWJHq0pZL7BHKh4=
From: Andrey Borzenkov <arvidjaar@gmail.com>
To: Brian Haley <brian.haley@hp.com>
Subject: Re: [PATCH 0/2] Bonding: fix IPv6 module requirement regression
Date: Wed, 4 Mar 2009 07:20:30 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-1avb; KDE/4.2.1; i686; ; )
Cc: David Miller <davem@davemloft.net>,
       Vladislav Yasevich <vladislav.yasevich@hp.com>,
       Chuck Lever <chuck.lever@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Valdis.Kletnieks@vt.edu, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       bonding-devel@lists.sourceforge.net,
       "J.A. =?iso-8859-1?q?Magall=F3n?=" <jamagallon@ono.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Vosburgh <fubar@us.ibm.com>
References: <49ADE956.1020702@hp.com>
In-Reply-To: <49ADE956.1020702@hp.com>
MIME-Version: 1.0
Message-Id: <200903040720.34497.arvidjaar@gmail.com>
Content-Type: multipart/signed;
  boundary="nextPart88308515.dUNc3oDlVh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart88308515.dUNc3oDlVh
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 4 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2009 05:37:10 Brian Haley wrote:
> These patches fix the Bonding module's requirement to have the IPv6
> module loaded and configured by creating a new "disable" module
> parameter value for ipv6.ko.  This allows users who do not want any
> IPv6 addresses or sockets to be created to disable IPv6 support,
> while still loading the module and making it's symbols available.=20
> This can be specified in /etc/modprobe.conf (or similar) with
> "options ipv6 disable=3D1".
>

While this is definitely the right approach, it requires completely new=20
infrastructure to disable IPv6 (including resolving update issues). So I=20
guess this is post-2.6.29 material.




--nextPart88308515.dUNc3oDlVh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmuAZIACgkQR6LMutpd94ybuwCdGcBqN36xbrE8JuhW9jt5wICZ
nfIAnRAw0tvbiMvoJAQsPhmAUYDz0IGE
=QJyI
-----END PGP SIGNATURE-----

--nextPart88308515.dUNc3oDlVh--
