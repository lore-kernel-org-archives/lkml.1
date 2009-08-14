Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbZHNTIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbZHNTIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 15:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbZHNTIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 15:08:31 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43106 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbZHNTIb (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 15:08:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] perf record: Fix typo in pid_synthesize_comm_event
In-Reply-To: Your message of "Fri, 14 Aug 2009 15:26:32 -0300."
             <20090814182632.GF3490@ghostprotocols.net>
From: Valdis.Kletnieks@vt.edu
References: <20090814182632.GF3490@ghostprotocols.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1250276831_9206P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Aug 2009 15:07:11 -0400
Message-ID: <28379.1250276831@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1250276831_9206P
Content-Type: text/plain; charset=us-ascii

On Fri, 14 Aug 2009 15:26:32 -0300, Arnaldo Carvalho de Melo said:
> We were using 'fd' locally, but there was a global 'fd' too, so when
> converting from open to fopen the test made against fd should be made
> against 'fp', but since we have that global...

If the kernel was -Wshadow safe by default, this sort of thing would happen
less often... :)

--==_Exmh_1250276831_9206P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKhbXfcC3lWbTT17ARAu58AKCYEW2m/W08zrf09B9ZZoeS37VJ7ACcCyHU
04wEoxo5q8ioPGmGubgx/c0=
=x8qc
-----END PGP SIGNATURE-----

--==_Exmh_1250276831_9206P--
