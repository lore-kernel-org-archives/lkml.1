Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZARXqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZARXqD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 18:46:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZARXpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 18:45:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50351 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbZARXpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 18:45:51 -0500
Date: Mon, 19 Jan 2009 10:45:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Howells <dhowells@redhat.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: FS-Cache fixes for IA64 export and AFS linkage
Message-Id: <20090119104539.06511073.sfr@canb.auug.org.au>
In-Reply-To: <4973BB3F.8090702@oracle.com>
References: <16871.1232172044@redhat.com>
	<4973BB3F.8090702@oracle.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__19_Jan_2009_10_45_39_+1100_EweFNL.4s5Fs_cLD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Jan_2009_10_45_39_+1100_EweFNL.4s5Fs_cLD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 18 Jan 2009 15:29:03 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> David Howells wrote:
> > I've dropped the patch to export copy_page() for IA64 from my patchset =
and
> > updated the AFS patch so that it no longer produces link errors if
> > CONFIG_AFS_FS=3Dy and CONFIG_FSCACHE=3Dm but CONFIG_AFS_FSCACHE=3Dn.
> >=20
> > These patches are now available as:
> >=20
> > 	http://people.redhat.com/~dhowells/fscache/patches/nfs+fscache-44.tar.=
bz2
> >=20
> > and I've updated my GIT tree for Trond to pull:
> >=20
> > 	http://git.kernel.org/?p=3Dlinux/kernel/git/dhowells/linux-2.6-nfs-fsc=
ache.git;a=3Dshortlog
>=20
> Ack.  Builds for me.  Thanks.

And it will be in today's linux-next, since Trond has merged it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Jan_2009_10_45_39_+1100_EweFNL.4s5Fs_cLD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklzvyMACgkQjjKRsyhoI8y26QCgkuxCvkhMKtQA1OqDO2qrhVWF
PakAoLerLyMvqVAFewwreTcIdg+fuu85
=Emze
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Jan_2009_10_45_39_+1100_EweFNL.4s5Fs_cLD--
