Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbYEMFLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbYEMFLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 01:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbYEMFLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 01:11:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbYEMFLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 01:11:10 -0400
Message-ID: <482922E2.3040902@redhat.com>
Date: Mon, 12 May 2008 22:10:58 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 18/18] flag parameters: check magic constants
References: <200805062118.m46LI74j004096@devserv.devel.redhat.com>	<20080512201341.9ead6a9a.akpm@linux-foundation.org>	<482910FA.1080703@redhat.com>	<20080512.210225.167924945.davem@davemloft.net> <20080512220416.ef9a9645.akpm@linux-foundation.org>
In-Reply-To: <20080512220416.ef9a9645.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> m68k too..

I cannot build it here but looking at the headers:

- - include/asm-m68k/fcntl.h does not define O_NONBLOCK; and therefore

- - the definition from include/asm-generic/fcntl.h is used which is 04000


Is there any magic I miss?

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIKSLi2ijCOnn/RHQRAvItAJ45n2h20UasryYucg18pd9ERWUpbACglsvR
ftad99qXQ20UwezP0DjbssA=
=orzm
-----END PGP SIGNATURE-----
