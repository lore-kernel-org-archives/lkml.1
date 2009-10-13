Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbZJMDnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbZJMDnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 23:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbZJMDnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 23:43:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55147 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbZJMDnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 23:43:07 -0400
Date: Tue, 13 Oct 2009 14:42:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephane Eranian <eranian@googlemail.com>
Subject: linux-next: tip tree build warning
Message-Id: <20091013144223.369d616d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Oct_2009_14_42_23_+1100_tJsupIpg72h_.9nt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Oct_2009_14_42_23_+1100_tJsupIpg72h_.9nt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

arch/x86/kernel/cpu/perf_event.c: In function 'intel_get_event_idx':
arch/x86/kernel/cpu/perf_event.c:1445: warning: 'event_constraint' is used =
uninitialized in this function

Introduced by commit b690081d4d3f6a23541493f1682835c3cd5c54a1
("perf_events: Add event constraints support for Intel processors").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Oct_2009_14_42_23_+1100_tJsupIpg72h_.9nt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrT9x8ACgkQjjKRsyhoI8x2vACeMhamiBrRtoCxBPhuq5qjkebp
37AAn1SrUMkVynwR6Xp5XJR5PVVhAMIy
=sBuC
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Oct_2009_14_42_23_+1100_tJsupIpg72h_.9nt--
