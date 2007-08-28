Return-Path: <linux-kernel-owner+w=401wt.eu-S1763439AbXH1T7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763439AbXH1T7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXH1T7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:59:44 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39308 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbXH1T7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:59:43 -0400
Message-ID: <46D47E69.1000804@us.ibm.com>
Date: Tue, 28 Aug 2007 12:58:33 -0700
From: Ian Romanick <idr@us.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: m.kozlowski@tuxland.pl
CC: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/23] introduce drm_zalloc as a drm_alloc + memset replacement
References: <20070827205750.514001000@tuxland.pl> <20070827211341.994873000@tuxland.pl>
In-Reply-To: <20070827211341.994873000@tuxland.pl>
X-Enigmail-Version: 0.95.3
OpenPGP: id=AC84030F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Instead of adding drm_zalloc, why not just use drm_calloc?  At the very
least just make drm_zalloc a macro that calls drm_calloc.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG1H5pX1gOwKyEAw8RAuXrAJ9W+Oyaimcedg0LdDqwqfMgX9Gl2QCeM9BM
sdiP4BDvLirsYex5hqhHsFc=
=/qZb
-----END PGP SIGNATURE-----
