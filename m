Return-Path: <linux-kernel-owner+w=401wt.eu-S1763808AbYCEVzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763808AbYCEVzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763008AbYCEVyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:54:40 -0500
Received: from asterix.m2000.com ([212.155.102.83]:3149 "EHLO
	asterix.m2000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762767AbYCEVyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:54:39 -0500
X-Greylist: delayed 1843 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2008 16:54:38 EST
Message-ID: <47CF0F4B.60801@m2000.com>
Date: Wed, 05 Mar 2008 13:23:23 -0800
From: Adam Schrotenboer <adam@m2000.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Cc: Thomas Daniel <tdaniel@m2000.com>, jesper.juhl@gmail.com,
       Trond.Myklebust@netapp.com, Neil Brown <neilb@suse.de>
Subject: nfs_update_inode: inode X mode changed, Y to Z [repost with correct
 address]
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig05E66CCB86BB1B71C2C40CB6"
X-Antivirus: avast! (VPS 080305-0, 03/05/2008), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig05E66CCB86BB1B71C2C40CB6
Content-Type: multipart/mixed;
 boundary="------------050103040301050606010701"

This is a multi-part message in MIME format.
--------------050103040301050606010701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

      Running SLES 10 on multiple compute nodes, with an OpenSuSE 10.2 NF=
S
server, and I am receiving the above log message on a semi-regular basis
in the NFS client system-logs. When this occurs, one of the users
receives an error (although there seems to be no way to easily collate
the users experience with the system log, short of using the timestamp).
      Sometimes it's "read/write error", sometimes it's more specific
about something that was a file now being a directory (SVN tends to be
rather more verbose). Most of the time this is just a nuisance, but at
times (such as last week or so) it occurs so often that it blocks any
work getting done.

      The NFS Server is running OpenSuSE 10.2 on a Dell PowerEdge 2900
with the PERC5/i controller. The NFS Clients are all SLES10 with the
standard mountoptions, and running in TCP mode (something about UDP +
NFS + GbE leads to subtle data corruption).

      I have been able to find some references to this problem in Google,=

but no solutions, and no discussion about what the problem stems from,
nor if any fixes have been attempted.





--------------050103040301050606010701
Content-Type: application/pgp-signature;
 name="signature.asc"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="signature.asc"

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0NClZlcnNpb246IEdudVBHIHYxLjQuNyAo
TWluZ1czMikNCkNvbW1lbnQ6IFVzaW5nIEdudVBHIHdpdGggTW96aWxsYSAtIGh0dHA6Ly9l
bmlnbWFpbC5tb3pkZXYub3JnDQoNCmlEOERCUUZIendncnlXWURkdm5HQXJ3UkF2aFZBSjkw
NXZDMFNRZW1qQ283Y25TK2JjbWw2U2l6SmdDZ2k1QTQNCnJ3R1pRMWd1c1FGckpEVThnZ09r
WlVBPQ0KPWZiRDYNCi0tLS0tRU5EIFBHUCBTSUdOQVRVUkUtLS0tLQ0KDQo=
--------------050103040301050606010701--

--------------enig05E66CCB86BB1B71C2C40CB6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHzw9LyWYDdvnGArwRAsCuAJwNQTPfntziVsEygVd9Nw0A1X5lTACghrHU
OvID4tAF2hBVXCJczOJG5iE=
=6UHB
-----END PGP SIGNATURE-----

--------------enig05E66CCB86BB1B71C2C40CB6--
