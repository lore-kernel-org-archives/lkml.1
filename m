Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbZGGOZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbZGGOZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbZGGOZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:25:10 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38352 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241AbZGGOZJ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:25:09 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: a.p.zijlstra@chello.nl, peterz@infradead.org,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 'config EVENT_PROFILE' - how does it ever work?
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1246973627_2719P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 07 Jul 2009 09:33:47 -0400
Message-ID: <11231.1246973627@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246973627_2719P
Content-Type: text/plain; charset=us-ascii

Peter - where do you prefer your e-mail?  MAINTAINERS for 'perf' gives this
chello.nl address, but peterz@infradead.org for other stuff? Sending to both
just in case...

Found this while trying to figure out why there was a one-entry menu
for performance counters.

Commit e077df4f adds to init/Kconfig this code:

config EVENT_PROFILE
        bool "Tracepoint profile sources"
        depends on PERF_COUNTERS && EVENT_TRACER
        default y

But there's no other usage of EVENT_TRACER I can find other than a lot
of 'EVENT_TRACER is not set' entries in defconfigs.  Is this an actual bug,
or did I lose the plot someplace?

--==_Exmh_1246973627_2719P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKU067cC3lWbTT17ARApT1AKDalg/CRRDgOTnvN+5LJm0bMShsggCeOX5K
pjUyllQ11iil6qEwXj9yX5U=
=7tKL
-----END PGP SIGNATURE-----

--==_Exmh_1246973627_2719P--
