Return-Path: <linux-kernel-owner+w=401wt.eu-S1764422AbXJOQNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764422AbXJOQNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758451AbXJOQNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:13:47 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:37403 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757973AbXJOQNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:13:46 -0400
Subject: Re: 2.6.23-mm1
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Laurent Riffard <laurent.riffard@free.fr>, linux-kernel@vger.kernel.org,
       reiserfs-devel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20071012140023.30e5b30e.akpm@linux-foundation.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <470FDB41.2000102@free.fr>
	 <20071012140023.30e5b30e.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Q+5ntblhmQ03ZlT+niwl"
Date: Mon, 15 Oct 2007 10:13:38 -0600
Message-Id: <1192464818.8642.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20071015/1IhSZX-0006q3-FK-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Q+5ntblhmQ03ZlT+niwl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-12 at 14:00 -0700, Andrew Morton wrote:
> On Fri, 12 Oct 2007 22:38:25 +0200
> Laurent Riffard <laurent.riffard@free.fr> wrote:
>=20
> > Le 12.10.2007 06:31, Andrew Morton a =E9crit :
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/=
2.6.23-mm1/
> >=20
> > Mounting reiser4 fs does hang with these messages in dmesg:
> >=20
> >   Loading Reiser4. See www.namesys.com for a description of Reiser4.
> >   reiser4[swapper(0)]: end_bio_single_page_read (fs/reiser4/page_cache.=
c:331)[nikita-3332]:
> >   WARNING: Truncated single page read: 4096
> >=20
> > Hitting SysRq-W produces this output:
> >=20
> >   SysRq : Show Blocked State
> >     task                PC stack   pid father
> >   mount         D c20d6b70  1592  2509   2495
> >          c229bbd8 00000046 c239d684 c20d6b70 e0824b8d c229bc10 00000000=
 c229bc18=20
> >          c229bbe0 c02ac14e c229bbe8 c0141b7b c229bc04 c02ac344 c0141b45=
 c1402654=20
> >          c1045f60 c1045f60 c229bc10 c229bc30 c0141d6e 00000002 c1045f60=
 00000000=20
> >   Call Trace:
> >    [<c02ac14e>] io_schedule+0xe/0x16
> >    [<c0141b7b>] sync_page+0x36/0x3a
> >    [<c02ac344>] __wait_on_bit+0x36/0x5d
> >    [<c0141d6e>] wait_on_page_bit+0x55/0x5b
> >    [<e1c0e1a6>] jload_gfp+0x73/0x163 [reiser4]
> >    [<e1c1c7f8>] load_journal_control_block+0x4d/0x77 [reiser4]
> >    [<e1c1c86e>] reiser4_init_journal_info+0x2b/0x54 [reiser4]
> >    [<e1c454e6>] init_format_format40+0x79/0x4ab [reiser4]
> >    [<e1c21cf8>] fill_super+0xce/0x1ee [reiser4]
> >    [<c015f731>] get_sb_bdev+0xe0/0x11e
> >    [<e1c21a8f>] reiser4_get_sb+0x13/0x15 [reiser4]
> >    [<c015f336>] vfs_kern_mount+0x3b/0x76
> >    [<c0171621>] do_mount+0x68a/0x7a3
> >    [<c01717a2>] sys_mount+0x68/0xa4
> >    [<c0103dee>] sysenter_past_esp+0x5f/0x99
> >    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>=20
> ho hum.  Maybe reiser4 needs updating for the git-block changes.
>=20
> I don't recall having seen a useful description of what's going on
> in git-block so some reverse-engineering might be needed.

Hmm.  I can add more data to this.  My x86_64 mode laptop is running
2.6.23-mm1 with Reiser4 and does not experience problems.

I am using 64-bit kernel, libata (I think, whatever the SCSI-like PATA
is called), and Reiser4.  Both libata and Reiser4 are built-in, not
modules.
--=20
Zan Lynx <zlynx@acm.org>

--=-Q+5ntblhmQ03ZlT+niwl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHE5GyG8fHaOLTWwgRAhS+AJ4kkY0Ck5S9lqAfMheINtRN/+NJ7gCZARrY
YYpM5rSrN5FPzouQwzUxozk=
=2pWg
-----END PGP SIGNATURE-----

--=-Q+5ntblhmQ03ZlT+niwl--

