Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbZIKBEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbZIKBEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 21:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZIKBEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 21:04:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:48893 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbZIKBEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 21:04:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,367,1249282800"; 
   d="asc'?scan'208";a="447570559"
Date: Fri, 11 Sep 2009 09:03:42 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, stern@rowland.harvard.edu
Subject: Re: [PATCH 1/3] agp/intel: remove restore in resume
Message-ID: <20090911010342.GA6819@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	stable@kernel.org, stern@rowland.harvard.edu
References: <1252028615-13785-1-git-send-email-zhenyuw@linux.intel.com>
 <20090910134252.5fc54ce2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <20090910134252.5fc54ce2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2009.09.10 13:42:52 -0700, Andrew Morton wrote:
> On Fri,  4 Sep 2009 09:43:34 +0800
> Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
>=20
> > As early pci resume has already restored config for host
> > bridge and graphics device, don't need to restore it again,
> > which might cause problem on some chips, like 845G tested by
> > Alan Stern.
> >=20
> > Cc: Stable Team <stable@kernel.org>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
>=20
> Why were these patches cc'ed to stable@kernel.org?  There's nothing in
> the changelog which explains why the problem which is being fixed is
> sufficiently serious to warrant backporting the patch.

Sorry, Andrew. I wasn't awared that an earlier version of this patch
has already been merged, and this patch fixed resume issue on Alan's
845G, which was discussed on linux-pm list, I should have made more
clear note about that. We've also seen other resume failure bugs, which
might be relate to this one. So I think it should be fine for stable.

>=20
> Was there a [patch 3/3]?  I didn't receive it.

sorry, my mistake, the 3/3 commit on my tree is not ready to send,=20
forget to make git format-patch happy.

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqpoe4ACgkQsQQaM014GCcg0gCeI4TxGV250oSLXK+G1/+1oCJg
COwAn0WNlPJCAzxcEt4CFrDuJd+UJfx9
=Wosv
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
