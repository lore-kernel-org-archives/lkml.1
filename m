Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416Ab0AXXeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab0AXXeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558Ab0AXXeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:34:15 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54631 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab0AXXeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:34:11 -0500
Date: Mon, 25 Jan 2010 10:33:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: The Ambient Light Sensors for-next tree
Message-Id: <20100125103357.076abef7.sfr@canb.auug.org.au>
In-Reply-To: <4B59C372.9090204@cam.ac.uk>
References: <4B59C372.9090204@cam.ac.uk>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Jan_2010_10_33_57_+1100_o_G7KtsaLEi_=CNT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Jan_2010_10_33_57_+1100_o_G7KtsaLEi_=CNT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jonathan,

On Fri, 22 Jan 2010 15:25:38 +0000 Jonathan Cameron <jic23@cam.ac.uk> wrote:
>
> The ambient light sensors (ALS) patches have been on lkml for a while and
> the core has now been thoroughly reviewed.  The actual drivers
> will follow shortly as most are moves from elsewhere in the kernel tree.
>=20
> Zhang Rui <rui.zhang@intel.com> is acting as the principle maintainer,
> whilst I'm handling the git tree and assisting with the more
> embedded devices.
>=20
> To that end there is a git tree at:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/jic23/als.git for-next
>=20
> and we were wondering if you could add this tree to linux-next?
> I've verified it applies cleanly on top of the current linux-next tree
> so it should merge fine *crosses fingers*

I have added the als tree to linux-next from today with you and Zhang Rui
listed as contacts for any problems.  I have cc'd this email to the more
general community so that people are aware of its inclusion.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Mon__25_Jan_2010_10_33_57_+1100_o_G7KtsaLEi_=CNT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktc2OUACgkQjjKRsyhoI8z2KQCdFutZFy8T75QjmYizy1Rm7EJ5
MokAnjaJtJbPyjApGDyln2ZtrN/sVglA
=aL6e
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Jan_2010_10_33_57_+1100_o_G7KtsaLEi_=CNT--
