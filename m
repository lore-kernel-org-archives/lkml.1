Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYCLSGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYCLSGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYCLSGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:06:23 -0400
Received: from asterix.m2000.com ([212.155.102.83]:3088 "EHLO
	asterix.m2000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbYCLSGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:06:21 -0400
Message-ID: <47D81B8A.7040702@m2000.com>
Date: Wed, 12 Mar 2008 11:06:02 -0700
From: Adam Schrotenboer <adam@m2000.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Stephan Jansen <jansen@astro.wisc.edu>
Cc: opensuse@opensuse.org, Thomas Daniel <tdaniel@m2000.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       jesper.juhl@gmail.com, Fred Revenu <frevenu@m2000.com>,
       Neil Brown <neilb@suse.de>
Subject: Re: [opensuse] nfs_update_inode: inode X mode changed, Y to Z
References: <47C5EC81.6080004@m2000.com> <47C71EC6.3050702@m2000.com> <3AD71C5E-B45A-4BDB-8C94-73D62256BEBF@astro.wisc.edu>
In-Reply-To: <3AD71C5E-B45A-4BDB-8C94-73D62256BEBF@astro.wisc.edu>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3AA27CAB1B4215B4C2494F5B"
X-Antivirus: avast! (VPS 080311-0, 03/11/2008), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3AA27CAB1B4215B4C2494F5B
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Stephan Jansen wrote:
>
> Hi,
>
> We've just run into a similar thing.  We have an OpenSuSE 10.3 NFS serv=
er
> exporting a filesystem to about 40 machines, most of which are also
> running OpenSuSE 10.3.  The client machines are running a distributed
> data processing pipeline.  The clients create, move and delete=20
> directories
> and files on the server.  We've seen a few instances where the=20
> programs on
> the clients die with a "no such file or directory" error but no errors =
in
> syslog.  Finally last night many of the clients gave these errors in=20
> syslog
> at about the same time as the client programs died with "no such file o=
r
> directory" errors:
>
> Mar 11 20:57:53 glimpse5 kernel: nfs_update_inode: inode 402653248=20
> mode changed, 0100644 to 0040755
> Mar 11 20:57:54 glimpse6 kernel: nfs_update_inode: inode 402653248=20
> mode changed, 0100644 to 0040755
> Mar 11 20:57:49 tsingtao kernel: nfs_update_inode: inode 402653248=20
> mode changed, 0100644 to 0040755
> Mar 11 20:57:16 glimpse12 kernel: nfs_update_inode: inode 402653248=20
> mode changed, 0100644 to 0040755
> Mar 11 20:59:04 cecilia kernel: nfs_update_inode: inode 402653248 mode =

> changed, 0100644 to 0040755
> Mar 11 20:59:11 glimpse28 kernel: nfs_update_inode: inode 402653248=20
> mode changed, 0100644 to 0040755
> Mar 11 20:58:20 glimpse27 kernel: nfs_update_inode: inode 402653248=20
> mode changed, 0100644 to 0040755
> Mar 11 20:59:12 glimpse18 kernel: nfs_update_inode: inode 402653248=20
> mode changed, 0100644 to 0040755
> Mar 11 20:58:22 glimpse19 kernel: nfs_update_inode: inode 402653248=20
> mode changed, 0100644 to 0040755
> Mar 11 20:59:25 glimpse20 kernel: nfs_update_inode: inode 402653248=20
> mode changed, 0100644 to 0040755
> Mar 11 20:58:35 glimpse21 kernel: nfs_update_inode: inode 402653248=20
> mode changed, 0100644 to 0040755
> Mar 11 20:59:27 glimpse22 kernel: nfs_update_inode: inode 402653248=20
> mode changed, 0100644 to 0040755
> Mar 11 20:59:27 glimpse23 kernel: nfs_update_inode: inode 402653248=20
> mode changed, 0100644 to 0040755
> Mar 11 20:59:39 glimpse24 kernel: nfs_update_inode: inode 402653248=20
> mode changed, 0100644 to 0040755
>
> I notice that the offending inodes are all the same.  This all worked=20
> without
> problems when the NFS server was SuSE 10.0.  The exported filesystem=20
> is XFS.
>
> Anyone have any ideas what's going on?
I personally don't, but I have a running thread with some of the NFS=20
maintainers, that I have added this mail to now.


--------------enig3AA27CAB1B4215B4C2494F5B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH2BuKyWYDdvnGArwRAv49AJ9Oni5roL8rkCFtIbXYt2STSqHkXQCbB79I
wugF6kM0BAkvaIr/PEvuRHI=
=ssmx
-----END PGP SIGNATURE-----

--------------enig3AA27CAB1B4215B4C2494F5B--
