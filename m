Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0CBBPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 20:15:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37214 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab0CBBPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 20:15:36 -0500
Date: Tue, 2 Mar 2010 12:15:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for March 1 (bluetooth/hci_sysfs)
Message-Id: <20100302121526.36a1ea88.sfr@canb.auug.org.au>
In-Reply-To: <4B8C2CC5.8000603@oracle.com>
References: <20100301210210.c6f465e6.sfr@canb.auug.org.au>
	<4B8C2CC5.8000603@oracle.com>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Mar_2010_12_15_26_+1100_x6.bYRwK6xFgMQ=b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Mar_2010_12_15_26_+1100_x6.bYRwK6xFgMQ=b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Mon, 01 Mar 2010 13:08:21 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> static ssize_t inquiry_cache_read(struct file *file, char __user *userbuf,
> 						size_t count, loff_t *ppos)
> {
> 	struct hci_dev *hdev =3D file->private_data;
> 	struct inquiry_cache *cache =3D &hdev->inq_cache;
> 	struct inquiry_entry *e;
> 	char buf[4096]; // <<<<<<<<<<<<<<<<<<<<<<<<<<< huh? don't do that on sta=
ck.
> 	int n =3D 0;

Dave Miller is following up on that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Mar_2010_12_15_26_+1100_x6.bYRwK6xFgMQ=b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuMZq4ACgkQjjKRsyhoI8wekQCeM8K375Jt7YKI2HRifcC9lXHS
Z7UAnir+PiJ7hIHWbXeWGtTWQcH9yjXu
=QUPf
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Mar_2010_12_15_26_+1100_x6.bYRwK6xFgMQ=b--
