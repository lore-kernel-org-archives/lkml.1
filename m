Return-Path: <linux-kernel-owner+w=401wt.eu-S934615AbZKYJE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934615AbZKYJE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934551AbZKYJEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:04:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58747 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934493AbZKYJEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:04:50 -0500
Date: Wed, 25 Nov 2009 20:04:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steve French <sfrench@us.ibm.com>, Jeff Layton <jlayton@redhat.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: linux-next: manual merge of the ext3 tree with the cifs tree
Message-Id: <20091125200444.cab8f918.sfr@canb.auug.org.au>
In-Reply-To: <20091125085006.GB549@quack.suse.cz>
References: <20091125140626.2b71fb0a.sfr@canb.auug.org.au>
	<20091125085006.GB549@quack.suse.cz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_Nov_2009_20_04_44_+1100_XBPeMR4555t/tbnD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Nov_2009_20_04_44_+1100_XBPeMR4555t/tbnD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

On Wed, 25 Nov 2009 09:50:06 +0100 Jan Kara <jack@suse.cz> wrote:
>
> On Wed 25-11-09 14:06:26, Stephen Rothwell wrote:
> > Today's linux-next merge of the ext3 tree got a conflict in fs/cifs/dir=
.c
> > between commit cea62343956c24452700c06cf028b72414c58a74 ("[CIFS]
> > Duplicate data on appending to some Samba servers") from the cifs tree
> > and commit 618903228b94b67a1d04634a83ea9cdb99c09e37 ("vfs: Implement
> > proper O_SYNC semantics") from the ext3 tree.
>   Thanks for notification and fixup.
>=20
> > Just context changes.  I fixed it up (see below) and can carry the fix =
as
> > necessary.
>   Looking at the code, I don't see an easy way of resolving this by chang=
ing
> either mine or CIFS tree - I have other patches depending on this and this
> patch depending on others and I assume it's similar with CIFS... So I gue=
ss
> we'll have to live with this conflict.

Its not a big issue and even if it hits Linus' tree that way, I think he
would not mind.

I have just noticed that I get the same conflict between the cifs tree
and the fsnotify tree (hi Eric!) which has also included that patch from
Christoph.  Again, not a big problem.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_Nov_2009_20_04_44_+1100_XBPeMR4555t/tbnD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksM8ywACgkQjjKRsyhoI8yntgCfdnY7/Rgu1wRRj0w2HY6Hm8Ht
jC4AnRYymCzhEs3oFL1TJhXdtUZz6vOs
=N30n
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Nov_2009_20_04_44_+1100_XBPeMR4555t/tbnD--
