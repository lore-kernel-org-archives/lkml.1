Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbXIIDVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbXIIDVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 23:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbXIIDVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 23:21:09 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37012 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbXIIDVI (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 23:21:08 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <ak@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, jakub@redhat.com,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1 - vdso and gettimeofday issues with glibc
In-Reply-To: Your message of "Sat, 08 Sep 2007 10:57:50 +0200."
             <200709081057.51144.ak@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <200709011207.58201.ak@suse.de> <46E1A8ED.8090104@redhat.com>
            <200709081057.51144.ak@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1189308056_2988P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 08 Sep 2007 23:20:56 -0400
Message-ID: <16909.1189308056@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1189308056_2988P
Content-Type: text/plain; charset=us-ascii

On Sat, 08 Sep 2007 10:57:50 +0200, Andi Kleen said:

> vdso effectively only supports TSC and HPET (the other clock sources are not accessible
> from ring 3)

Ahh.. that explains why acpi_pm clocksource doesn't trip over the problem....

--==_Exmh_1189308056_2988P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG42aYcC3lWbTT17ARAijuAKC7QRLhQK8ZrFfrFAONKVKSza8I8wCcCQ0/
P+AXaEIdpdjPkqbgWYk5WTQ=
=pelD
-----END PGP SIGNATURE-----

--==_Exmh_1189308056_2988P--
