Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbZIQB4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbZIQB4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 21:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbZIQB4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 21:56:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58078 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbZIQB4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 21:56:34 -0400
Date: Thu, 17 Sep 2009 11:56:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       reiserfs-devel@vger.kernel.org, jeffm@suse.com
Subject: Re: [PATCH] reiserfs: Truncate blocks not used by a write (v2)
Message-Id: <20090917115629.6f8f8f00.sfr@canb.auug.org.au>
In-Reply-To: <20090917005633.GC8098@nowhere>
References: <1253121912-20718-1-git-send-email-jack@suse.cz>
	<20090916144815.e544b319.akpm@linux-foundation.org>
	<20090917005633.GC8098@nowhere>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Sep_2009_11_56_29_+1000_S6fxau8kbRrqt9wa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Sep_2009_11_56_29_+1000_S6fxau8kbRrqt9wa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Frederic,

On Thu, 17 Sep 2009 02:56:34 +0200 Frederic Weisbecker <fweisbec@gmail.com>=
 wrote:
>
> Note that the kill-the-bkl/reiserfs tree has suffered from too much
> lock inversion problems lately. Even though I just fixed the last one
> reported, I would feel more comfortable to schedule this tree for .33
> rather than .32
>=20
> So this tree can be removed from -next and reintegrated once -rc1 is
> released, without problem.

OK, I have removed it from today.  Please let me know when it should be
readded (in case I forget - which at my age is likely :-)).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Sep_2009_11_56_29_+1000_S6fxau8kbRrqt9wa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqxl00ACgkQjjKRsyhoI8zSbgCgh5yvlew8782uOExdZhLzB2eD
bGoAn37vinDdlpg0Re2a/x2Mrc/Qgn+5
=0vu0
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Sep_2009_11_56_29_+1000_S6fxau8kbRrqt9wa--
