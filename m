Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZEYFyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZEYFyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZEYFye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:54:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34939 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZEYFyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:54:33 -0400
Date: Mon, 25 May 2009 15:54:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
       Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: linux-next: block tree build failure
Message-Id: <20090525155426.28331f5f.sfr@canb.auug.org.au>
In-Reply-To: <yq1bpphg2st.fsf@sermon.lab.mkp.net>
References: <20090525143511.f9e76bdc.sfr@canb.auug.org.au>
	<yq1bpphg2st.fsf@sermon.lab.mkp.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_May_2009_15_54_26_+1000_c.eYP148V7JYzF.A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_May_2009_15_54_26_+1000_c.eYP148V7JYzF.A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Martin,

On Mon, 25 May 2009 01:38:26 -0400 "Martin K. Petersen" <martin.petersen@or=
acle.com> wrote:
>
> The accessor function patch in my patch series was explicitly put in
> place to enable changing the API without affecting users.  And we've
> tried to be careful about staging these patches in the right order
> throughout all the involved trees.

What you really need is to have the patches that introduce the accessors
in a tree common to all the possible users of them.  In practise this
often means Linus' tree - in which case the patches should introduce noop
versions of the accessors.  If that is possible, Linus is quite happy to
take those patches after which all the other users can take the
conversions into their own tree and everyone is happy.  :-)

Currently the patches that introduce the accessors only exist in the
block tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_May_2009_15_54_26_+1000_c.eYP148V7JYzF.A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoaMpIACgkQjjKRsyhoI8xF4QCgj8sl8pkG8IIMBn7/SjJ9La6U
xxQAoJOFIFAfPmnXZYFujW1bLRdh17/N
=kA9b
-----END PGP SIGNATURE-----

--Signature=_Mon__25_May_2009_15_54_26_+1000_c.eYP148V7JYzF.A--
