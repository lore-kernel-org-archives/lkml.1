Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYLMDe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYLMDe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 22:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYLMDeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 22:34:46 -0500
Received: from virgo.iok.hu ([212.40.97.103]:58082 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbYLMDeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 22:34:46 -0500
Date: Sat, 13 Dec 2008 04:34:43 +0100
From: Miklos Vajna <vmiklos@frugalware.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplified GIT usage guide
Message-ID: <20081213033443.GP5691@genesis.frugalware.org>
References: <20081212190900.GL5691@genesis.frugalware.org> <20081212185347.GK5691@genesis.frugalware.org> <20081212182827.28408.40963.stgit@warthog.procyon.org.uk> <28996.1229108561@redhat.com> <32096.1229130776@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZa61AII3s1sGKYx"
Content-Disposition: inline
In-Reply-To: <32096.1229130776@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZa61AII3s1sGKYx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 13, 2008 at 01:12:56AM +0000, David Howells <dhowells@redhat.com> wrote:
> Okay.  I do mention tags.  How they're stored in the database is irrelevant.
> As far as most users need be concerned, a tag is a symbolic representation of
> a particular commit in the tree; a particular state of the source tree.

Actually I think it matters, that's why a 'tag' differs to a 'tag
object'. Also, a tag can point to any other object, not just to a
commit. (Though usually it does.)

> Think of symbolic links as an analogy.  Most users just need to know that a
> symlink represents the location of another part of the VFS tree; actually most
> users will just think of them as a pointer to the name of a file, if even that
> much.  The fact that, say, ReiserFS tail packs them because they tend to be
> small, or that AFS symlinks have weird properties that encode mountpoints is
> irrelevant to most users.  You don't need to know that to use them.

Won't it be confusing that a symlink can be stored as a blob, tags are
refs, but refs are not blobs?

> Yes, GIT's database has blob objects, tree objects, commit objects and tag
> objects; but as far as the normal user is concerned, it stores files, lists of
> files (directories or, more probably, folders), commits and tags.  The
> physical low-level stuff is completely irrelevant.

Agreed, the object database is not interesting for a beginner.

--YZa61AII3s1sGKYx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklDLVMACgkQe81tAgORUJbiOwCdFU1NRtmQp+rH9XF2Hyc7GYN3
PIoAn0tWKYPBEtWCVTP8eL9oW8ChjlTV
=7x97
-----END PGP SIGNATURE-----

--YZa61AII3s1sGKYx--
