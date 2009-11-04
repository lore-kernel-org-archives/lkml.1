Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbZKDR7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbZKDR7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbZKDR7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:59:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbZKDR7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:59:39 -0500
Date: Wed, 4 Nov 2009 11:59:06 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Subject: [PATCH 0/2] debugfs utility routines for perf
Message-ID: <20091104115906.7045cf65@torg>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ilIIj4NCZ79TD/cM+K1MeyB"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ilIIj4NCZ79TD/cM+K1MeyB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Ingo,

Here are the cleaned-up debugfs routines.

Clark


Clark Williams (2):
  debugfs utility routines for perf
  modify perf routines to use new debugfs routines

 tools/perf/perf.c              |   45 +------
 tools/perf/util/debugfs.c      |  247 ++++++++++++++++++++++++++++++++++++=
++++
 tools/perf/util/debugfs.h      |   22 ++++
 tools/perf/util/parse-events.c |   17 +--
 4 files changed, 280 insertions(+), 51 deletions(-)
 create mode 100644 tools/perf/util/debugfs.c
 create mode 100644 tools/perf/util/debugfs.h


--Sig_/ilIIj4NCZ79TD/cM+K1MeyB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkrxwO4ACgkQHyuj/+TTEp245gCeOWwEOSaXMUaEjMUPsduHaM+X
zfMAoJhc7Jz+sLdSdQoRoX1VyQEd+1ka
=h60v
-----END PGP SIGNATURE-----

--Sig_/ilIIj4NCZ79TD/cM+K1MeyB--
