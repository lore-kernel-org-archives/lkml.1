Return-Path: <linux-kernel-owner+w=401wt.eu-S933525AbXGYQIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525AbXGYQIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764165AbXGYQIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:08:30 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:32924 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761661AbXGYQI3 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:08:29 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ingo Molnar <mingo@elte.hu>
Cc: Rene Herman <rene.herman@gmail.com>, david@lang.hm,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
In-Reply-To: Your message of "Wed, 25 Jul 2007 13:34:01 +0200."
             <20070725113401.GA23341@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com> <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com> <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm> <46A6DFFD.9030202@gmail.com> <30701.1185347660@turing-police.cc.vt.edu> <46A7074B.50608@gmail.com> <20070725082822.GA13098@elte.hu> <46A70D37.3060005@gmail.com>
            <20070725113401.GA23341@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1185379688_3413P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 25 Jul 2007 12:08:08 -0400
Message-ID: <24826.1185379688@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1185379688_3413P
Content-Type: text/plain; charset=us-ascii

On Wed, 25 Jul 2007 13:34:01 +0200, Ingo Molnar said:

> Maybe the kernel could be extended with a method of opening files in a 
> 'drop from the dcache after use' way. (beagled and backup tools could 
> make use of that facility too.) (Or some other sort of 
> file-cache-invalidation syscall that already exist, which would _also_ 
> result in the immediate zapping of the dentry+inode from the dcache.)

The semantic that would benefit my work patterns the most would not be
"immediate zapping" - I have 2G of RAM, so often there's no memory pressure,
and often a 'find' will be followed by another similar 'find' that will hit a
lot of the same dentries and inodes, so may as well save them if we can.
Flagging it as "the first to be heaved over the side the instant there *is*
pressure" would suit just fine.

Or is that the semantic you actually meant?


--==_Exmh_1185379688_3413P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGp3VocC3lWbTT17ARAs+kAKC7KVnf8TLQYVv1Ie6Ecd55Thu+XQCeN6kI
/DvGcqYu6+dXJ+MyjvT7QoE=
=4y3F
-----END PGP SIGNATURE-----

--==_Exmh_1185379688_3413P--
