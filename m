Return-Path: <linux-kernel-owner+w=401wt.eu-S1422733AbXCBDCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422733AbXCBDCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 22:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422798AbXCBDCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 22:02:16 -0500
Received: from iucha.net ([209.98.146.184]:42667 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422733AbXCBDCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 22:02:14 -0500
Date: Thu, 1 Mar 2007 21:02:13 -0600
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: 2.6.20-rc1: CIFS cheers, NFS4 jeers
Message-ID: <20070302030212.GC29073@iucha.net>
References: <20070226064500.GZ29073@iucha.net> <20070228215234.d86a4886.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UxbNYeHgyZbry9TP"
Content-Disposition: inline
In-Reply-To: <20070228215234.d86a4886.akpm@linux-foundation.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--UxbNYeHgyZbry9TP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2007 at 09:52:34PM -0800, Andrew Morton wrote:
> On Mon, 26 Feb 2007 00:45:00 -0600 florin@iucha.net (Florin Iucha) wrote:
>=20
> > Hello, it's me and my 70 GB of photos again.
[snip]
> > Running 'top', one core is idle and the other is 99% waiting, while
> > the 'cp' program is in 'D' state.  Also, after NFSv4 stalls, invokations
> > of 'lsof' stall as well.  I can 'ssh' into the box without problems.
>=20
> and
>=20
> > The kernel on the client is 2.6.21-rc1 (but it echoes problems I
> > reported in December with 2.6.20 series as well) as can be seen from
> > the kernel logs.
> >=20
> > I have corrected the links:
> >=20
> >    http://iucha.net/21-rc1/before.1
> >    http://iucha.net/21-rc1/after.1
> >    http://iucha.net/21-rc1/config-2.6.21-rc1
> >=20
>=20
> The relevant part is:
>=20
> [ 1215.657827] cp            D 000000f86f105704     0  2859   2843       =
              (NOTLB)
> [ 1215.657833]  ffff81007343faa8 0000000000000082 0000000000000000 ffff81=
007343fb58
> [ 1215.657837]  0000000000000002 ffff81007343faa8 0000000000000008 ffff81=
007e578ee0
> [ 1215.657842]  ffff810002f4a080 0000000000002150 ffff81007e5790b8 000000=
017343fb50
> [ 1215.657847] Call Trace:
> [ 1215.657852]  [<ffffffff80160f4c>] io_schedule+0x28/0x34
> [ 1215.657856]  [<ffffffff80128517>] sync_page+0x41/0x45
> [ 1215.657859]  [<ffffffff80161294>] __wait_on_bit+0x45/0x77
> [ 1215.657862]  [<ffffffff801284d6>] sync_page+0x0/0x45
> [ 1215.657867]  [<ffffffff8013370c>] wait_on_page_bit+0x6e/0x75
> [ 1215.657870]  [<ffffffff801948ca>] wake_bit_function+0x0/0x2a
> [ 1215.657874]  [<ffffffff801454a2>] pagevec_lookup_tag+0x22/0x2b
> [ 1215.657878]  [<ffffffff80147317>] wait_on_page_writeback_range+0x6e/0x=
142
> [ 1215.657885]  [<ffffffff801a4a79>] filemap_fdatawait+0x20/0x22
> [ 1215.657889]  [<ffffffff801a4bfe>] filemap_write_and_wait+0x29/0x38
> [ 1215.657894]  [<ffffffff8023019a>] nfs_setattr+0xa0/0x11a
> [ 1215.657897]  [<ffffffff8010e30e>] link_path_walk+0xe8/0xfc
> [ 1215.657902]  [<ffffffff80194892>] autoremove_wake_function+0x0/0x38
> [ 1215.657907]  [<ffffffff80112377>] poison_obj+0x27/0x32
> [ 1215.657910]  [<ffffffff8010db3a>] current_fs_time+0x3f/0x41
> [ 1215.657913]  [<ffffffff80122f93>] __user_walk_fd+0x53/0x62
> [ 1215.657918]  [<ffffffff8012bc1b>] notify_change+0x129/0x238
> [ 1215.657923]  [<ffffffff801c5ccb>] do_utimes+0xfc/0x126
> [ 1215.657928]  [<ffffffff801077fc>] _raw_spin_lock+0xf3/0xf9
> [ 1215.657933]  [<ffffffff801c5d3a>] sys_futimesat+0x45/0x56
> [ 1215.657937]  [<ffffffff80150d3e>] sys_utimes+0x14/0x16
> [ 1215.657941]  [<ffffffff8015ac5e>] system_call+0x7e/0x83
>=20
> seems that we've simply lost an IO completion.
>=20
> Was 2.6.19 OK?

I just tested, 2.6.19 is OK!  Kernel log output after the cp and sync
completed are at

http://iucha.net/19/before
http://iucha.net/19/after  (after echo t > /proc/sysrq-trigger)

When I get a chance I will try again, and report if it fails.  But so far
it seems fine: df and lsof work as expected.

Thanks,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--UxbNYeHgyZbry9TP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF55O0ND0rFCN2b1sRAnkqAJ4+oRcw4jGsdILANrQGpGRCFepuOgCdG4ua
UUMeWUftrrqXzkjixt47+lA=
=SrLF
-----END PGP SIGNATURE-----

--UxbNYeHgyZbry9TP--
