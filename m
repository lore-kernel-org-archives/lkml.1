Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYJCG0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYJCG0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 02:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYJCG0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 02:26:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57932 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbYJCG0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 02:26:07 -0400
Message-ID: <48E5BAC6.9070007@redhat.com>
Date: Thu, 02 Oct 2008 23:25:10 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Kees Cook <kees.cook@canonical.com>, Jakub Jelinek <jakub@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
References: <20081001201116.GD12527@outflux.net>	<48E3EFD6.2010704@redhat.com>	<20081001215657.GH12527@outflux.net>	<20081001220948.GC32107@sunsite.ms.mff.cuni.cz>	<20081001222706.68E7E1544B4@magilla.localdomain>	<20081003001616.GN10632@outflux.net>	<20081003004340.GF32682@tyan-ft48-01.lab.bos.redhat.com>	<20081003052938.GS10632@outflux.net> <20081002225718.6a0d803a@infradead.org>
In-Reply-To: <20081002225718.6a0d803a@infradead.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Arjan van de Ven wrote:
> 16 bytes (say 4 vectors) is easier than "variable number of" both on the
> kernel and on the glibc side, and nobody other than maybe Ulrich
> and Jakub wouldn't know what to answer to the KConfig question anyway.

As Roland already wrote, I consider 16 bytes sufficient.  Everything
else will then be served via a PRNG which is seeded through the 16 bytes.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkjlusYACgkQ2ijCOnn/RHTOqwCghULjVoA+bZVlqv8eFhSHRPOt
jUYAoMNM+IXtS3HkVTZdFsH3kooSWFk2
=Z6f0
-----END PGP SIGNATURE-----
