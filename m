Return-Path: <linux-kernel-owner+w=401wt.eu-S939627AbYCTAHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939627AbYCTAHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbYCSXNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:13:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47794 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161067AbYCSXNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:13:32 -0400
Date: Thu, 20 Mar 2008 10:13:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       stern@rowland.harvard.edu, Andy Whitcroft <apw@shadowen.org>,
       lenb@kernel.org, greg@kroah.com, akpm@linux-foundation.org, rjw@sisk.pl
Subject: Re: [Build Failure] linux-next: Tree for March 18
Message-Id: <20080320101319.0dca1cd3.sfr@canb.auug.org.au>
In-Reply-To: <47DFA49D.4000007@linux.vnet.ibm.com>
References: <20080318205259.13726d23.sfr@canb.auug.org.au>
	<47DFA49D.4000007@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__20_Mar_2008_10_13_19_+1100_fUVsg9JJJ9ma6Dm5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Mar_2008_10_13_19_+1100_fUVsg9JJJ9ma6Dm5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kamalesh,

On Tue, 18 Mar 2008 16:46:45 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>
> The kernel build of linux-next tree(s) have been failing from 20080314 wi=
th
> the build failure
>=20
> drivers/serial/serial_core.c: In function `uart_add_one_port':
> drivers/serial/serial_core.c:2359: error: invalid lvalue in assignment
> make[2]: *** [drivers/serial/serial_core.o] Error 1
>=20
> And the patch was submitted for the same http://marc.info/?l=3Dlinux-next=
&m=3D120561799422065&w=3D2

Thanks for the report. I have reverted the patch in Greg's series that
causes the breakage until it is fixed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__20_Mar_2008_10_13_19_+1100_fUVsg9JJJ9ma6Dm5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH4Z4TTgG2atn1QN8RAvRFAJsFprcNX8Suy8vExRS4YeLAn2q7CQCgkrRN
+Y2JEbEd0TyZTfBS1N6ThcE=
=wu9f
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Mar_2008_10_13_19_+1100_fUVsg9JJJ9ma6Dm5--
