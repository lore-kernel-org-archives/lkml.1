Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYIZMfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYIZMfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYIZMfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:35:43 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36150 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbYIZMfm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:35:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org,
       dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk,
       mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Add timeout feature
In-Reply-To: Your message of "Fri, 26 Sep 2008 17:52:35 +0900."
             <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
From: Valdis.Kletnieks@vt.edu
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com>
            <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1222432525_7097P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Sep 2008 08:35:25 -0400
Message-ID: <35472.1222432525@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1222432525_7097P
Content-Type: text/plain; charset=us-ascii

On Fri, 26 Sep 2008 17:52:35 +0900, Takashi Sato said:

(Sorry, am reading the threads out of temporal sequence....)

> I think that your concern is that the freezer cannot recognize the occurrence
> of a timeout and it continues the backup process and the backup data is
> corrupted finally.
> If the freezer can recognize it by the unfreeze ioctl's errono, will your concern
>  be solved?
> If so, I will implement it.

That would also address my concerns about merging patches 8 and 10 of the
other patch series (because patch 10 wouldn't be needed then)...


--==_Exmh_1222432525_7097P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI3NcNcC3lWbTT17ARAlfSAJ9koC6IkAWpTwgQQzzxs0CHDfWf6ACgzm8C
gDUF+0x2+mjqNZBumGOhqOA=
=x5uP
-----END PGP SIGNATURE-----

--==_Exmh_1222432525_7097P--
