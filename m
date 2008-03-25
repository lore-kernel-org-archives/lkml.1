Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYCYOIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYCYOIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbYCYOId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:08:33 -0400
Received: from os.eurotux.com ([216.75.63.6]:36247 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYCYOIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:08:32 -0400
Date: Tue, 25 Mar 2008 14:08:25 +0000
From: Luciano Rocha <luciano@eurotux.com>
To: Michael Meyer <mike65134@yahoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 >
	/sys/devices/system/cpu/cpu1/online"
Message-ID: <20080325140825.GA19722@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Michael Meyer <mike65134@yahoo.de>, linux-kernel@vger.kernel.org
References: <16336.23884.qm@web25814.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <16336.23884.qm@web25814.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


On Tue, Mar 25, 2008 at 02:47:50PM +0100, Michael Meyer wrote:
> Hi,=20
>=20
> what is the difference between booting a dual core
> machine with "maxcpus=3D1" or by deactivating the second
> core at run time with "echo 0 >
> /sys/devices/system/cpu/cpu1/online"?

maxcpus=3D1 should turn off the SMP alternative and switch to UP only,
optimising some locks and instructions.

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFH6QdZinSul6a7oB8RAkOuAJ4oQv3IWvYoF/GHo+rgdj316/GGJACeJJpf
6VoLYTU5274kExEEtB3dl5k=
=u8LD
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
