Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbYJCO5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbYJCO5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYJCO5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:57:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49150 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbYJCO5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:57:40 -0400
Message-ID: <48E632B9.4090105@redhat.com>
Date: Fri, 03 Oct 2008 07:56:57 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for glibc PRNG seeding
References: <20081001201116.GD12527@outflux.net> <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <20081003004340.GF32682@tyan-ft48-01.lab.bos.redhat.com> <20081003052938.GS10632@outflux.net> <20081002225718.6a0d803a@infradead.org> <48E5BAC6.9070007@redhat.com> <20081003145054.GU10632@outflux.net>
In-Reply-To: <20081003145054.GU10632@outflux.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

There is no need for a AT_RANDOM_SIZE entry.  It's unlikely that ever a
different value is used.  The kernel's entropy pool cannot be strssed
that much.  If more data is needed userlevel will use the bits to seed a
PRNG.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjmMrkACgkQ2ijCOnn/RHS9QQCgvCKS9jKMmCI+ow3BmboHgjfb
5CAAni8Qohrs3qZ1RPa9fqCKMsUE355o
=9bI+
-----END PGP SIGNATURE-----
