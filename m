Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZLBEBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZLBEBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZLBEBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:01:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57028 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbZLBEBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:01:38 -0500
Date: Wed, 2 Dec 2009 15:01:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: manual merge of the acpi tree with the pci tree
Message-Id: <20091202150135.900cfe66.sfr@canb.auug.org.au>
In-Reply-To: <200912011340.21370.bjorn.helgaas@hp.com>
References: <20091126132228.85a63dee.sfr@canb.auug.org.au>
	<200911301526.07220.bjorn.helgaas@hp.com>
	<200912011340.21370.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Dec_2009_15_01_35_+1100_18AAwMWT=_OqK+pW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Dec_2009_15_01_35_+1100_18AAwMWT=_OqK+pW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

On Tue, 1 Dec 2009 13:40:19 -0700 Bjorn Helgaas <bjorn.helgaas@hp.com> wrot=
e:
>
> On Monday 30 November 2009 03:26:05 pm Bjorn Helgaas wrote:
> > On Wednesday 25 November 2009 07:22:28 pm Stephen Rothwell wrote:
> > > Today's linux-next merge of the acpi tree got a conflict in
> > > drivers/pci/hotplug/acpiphp_glue.c between commit
> > > 204d49a5613a06eb2fa5c3b842a29b1336cc7995 ("PCI hotplug: move IOAPIC
> > > support from acpiphp to ioapic driver") from the pci tree and commit
> > > 2263576cfc6e8f6ab038126c3254404b9fcb1c33 ("ACPICA: Add post-order
> > > callback to acpi_walk_namespace") from the acpi tree.
> > >=20
> > > The former moved part of the code modified by the latter into another
> > > file.  All the calls to acpi_walk_namespace() seem to have been remov=
ed
> > > in this process.
> >=20
> > I was on vacation last week, so couldn't respond earlier, sorry.
> >=20
> > As you noticed, 204d49a56 removed some acpi_walk_namespace() calls.
> > It removed calls to the old "pre-order only" version, while 263576cfc
> > converted acpi_walk_namespace() to a new "pre-order and post-order"
> > version.
> >=20
> > This is conceptually simple because 204d49a56 is just removing uses
> > of acpi_walk_namespace(), so we don't care at all whether it removes
> > calls to the old or new version.  But I don't have enough git-fu to
> > know how to fix this.
>=20
> Has this been resolved already?  Is there anything I can do to help?

I have a merge resolution in linux-next.  The resolution (simple as it
is) can just wait until the second of these two trees is merged into
Linus' tree (or the second tree could be fixed up my merging Linus' tree
after the first of the above trees is merged).

So currently, there is nothing to be done, I think, thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Dec_2009_15_01_35_+1100_18AAwMWT=_OqK+pW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksV5p8ACgkQjjKRsyhoI8xvGwCfWpEXelt9awcku6zlxbuDBfmK
XYAAoKRQ4YCHkFjSJJOJKYJwfd8kL7Ad
=A7hg
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Dec_2009_15_01_35_+1100_18AAwMWT=_OqK+pW--
