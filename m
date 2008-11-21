Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbYKURQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbYKURQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbYKURQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:16:45 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37799 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYKURQo (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:16:44 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jamie Lokier <jamie@shareable.org>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, trond.myklebust@fys.uio.no,
       viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 24/45] CacheFiles: Add a hook to write a single page of data to an inode [ver #41]
In-Reply-To: Your message of "Fri, 21 Nov 2008 13:00:30 GMT."
             <20081121130030.GE29831@shareable.org>
From: Valdis.Kletnieks@vt.edu
References: <20081121002317.69e4fd11.akpm@linux-foundation.org> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144343.10667.530.stgit@warthog.procyon.org.uk> <3843.1227271421@redhat.com>
            <20081121130030.GE29831@shareable.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1227287735_4186P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Nov 2008 12:15:35 -0500
Message-ID: <12060.1227287735@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1227287735_4186P
Content-Type: text/plain; charset=us-ascii

On Fri, 21 Nov 2008 13:00:30 GMT, Jamie Lokier said:
> Couldn't we just skip the "wasted" comment lines and go to //-style
> comments, since it's been standard GCC for what, 13 years now?  And
> standard ANSI C for some 9 years...

The problem is that // style comments tend to encourage *really* short
comments, because we're already hitting col 80:

	current->whizbang = some_random_func(dev->wombats, 0); //vryshrtcmmnt

Making people use block comments encourages this:

	/*
	 * Since we're committed to at least 3 lines anyhow, take an
	 * extra line or two and explain why we're checking dev->wombats,
	 * rather than the more obvious proto->giraffe field....
	 */
	current->whizbang = some_random_func(dev->wombats, 0);

(And before you ask, trying to ban // comments on the right-hand of code, and
using // for block comments rather than /*... */ is the worst of both worlds.


--==_Exmh_1227287735_4186P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJJuy3cC3lWbTT17ARAmGAAKDC/fCobJg81TskkceTToh1/NVyXQCeMn72
G3Xd6/7MdfxHcj19P3GObA8=
=wpI2
-----END PGP SIGNATURE-----

--==_Exmh_1227287735_4186P--
