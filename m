Return-Path: <linux-kernel-owner+w=401wt.eu-S934087AbZGQDNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087AbZGQDNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 23:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934050AbZGQDM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 23:12:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38084 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757600AbZGQDM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 23:12:59 -0400
Date: Fri, 17 Jul 2009 13:12:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: ttydev tree build failure
Message-Id: <20090717131253.af92ee00.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Jul_2009_13_12_53_+1000_+w./23S1./seFWim"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jul_2009_13_12_53_+1000_+w./23S1./seFWim
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

drivers/serial/icom.c: In function 'check_modem_status':
drivers/serial/icom.c:697: error: 'struct uart_state' has no member named '=
delta_msr_wait'

Caused by commit d663043b15626a1917587386da503e7943e434f6
("serial-kill-info").

So again I have used the ttydev tree from next-20090713.  Not having much
luck :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Jul_2009_13_12_53_+1000_+w./23S1./seFWim
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpf7DUACgkQjjKRsyhoI8xKegCdEWJ+uZ5j6k05L5RrhwMR8cBa
iVoAn20A/LIGn5b5QGX29+qvItuAAK9J
=tdMf
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jul_2009_13_12_53_+1000_+w./23S1./seFWim--
