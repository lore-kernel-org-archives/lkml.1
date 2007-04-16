Return-Path: <linux-kernel-owner+w=401wt.eu-S1030470AbXDPLic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030470AbXDPLic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 07:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030476AbXDPLic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 07:38:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:64202 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030470AbXDPLib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 07:38:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
        b=Pt/f0UnHlqyXSFlJ8Qt/AvC3ppZLXVMpNp0AhgwhH7SmyaQB2q+fkDLwo1QJbogUVGyXR4ptE5oyvv5sjYBvcp1HPVy2MYG+Rc2EKLMJI5oalgNZ7I0a2mTSFGZqS5Ul7KGcEmzGnE0F1AI0ihN9kH/jygt2gyWGo1b/lq3EtMU=
Date: Mon, 16 Apr 2007 04:38:22 -0700
From: Mike Mattie <codermattie@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.21-rc7 hpt366 driver broken
Message-ID: <20070416043822.0ea2490e@reforged>
In-Reply-To: <20070415224846.52a465b6@reforged>
References: <20070415224846.52a465b6@reforged>
X-Mailer: Claws Mail 2.6.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_GbNxYTlI=bc4Qldr2B7krv_";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_GbNxYTlI=bc4Qldr2B7krv_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 15 Apr 2007 22:48:46 -0700
Mike Mattie <codermattie@gmail.com> wrote:

> Hello,
>=20
> I am testing the 2.6.21-rc7 kernel release. The IDE hpt366 driver is
> crashing hanging the boot. I have basically the same config as
> 2.6.20.7 which works fine (except for netconsole mentioned in a
> previous mail).
>=20
> here is the hand-copied info:
>=20
> * "unable to handle paging request" , null deref
> * EIP @ init_chipset_hpt366
>=20

> I am running a git-bisect to see if I can resolve it to a commit.

This was identified as the first broken commit:

commit 7b73ee05d0acb926923d43d78b61add776ea4bb1
Author: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date:   Wed Feb 7 18:18:16 2007 +0100

    hpt366: init code rewrite

Reverting is conflicted so it will be a bit longer before I pin-point any o=
ther build-breaks.

> Cheers,
> Mike Mattie

--Sig_GbNxYTlI=bc4Qldr2B7krv_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGI2AzdfRchrkBInkRAsw2AJ9GyUErpgzB1qopRcRESLjJiOjRgwCg0jZj
FX6wKKGTwdOG2C0eNPzOwHY=
=GvY9
-----END PGP SIGNATURE-----

--Sig_GbNxYTlI=bc4Qldr2B7krv_--
