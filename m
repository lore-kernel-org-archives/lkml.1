Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYJCRnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYJCRnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYJCRmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:42:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60383 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbYJCRmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:42:54 -0400
Message-ID: <48E65964.5020809@redhat.com>
Date: Fri, 03 Oct 2008 10:41:56 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: Jakub Jelinek <jakub@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for glibc PRNG seeding
References: <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <20081003004340.GF32682@tyan-ft48-01.lab.bos.redhat.com> <20081003052938.GS10632@outflux.net> <20081002225718.6a0d803a@infradead.org> <48E5BAC6.9070007@redhat.com> <20081003145054.GU10632@outflux.net> <20081003145754.GH32682@tyan-ft48-01.lab.bos.redhat.com> <20081003173313.GW10632@outflux.net>
In-Reply-To: <20081003173313.GW10632@outflux.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Kees Cook wrote:
> +#ifndef ELF_AUXV_RANDOM_SIZE
> +/*
> + * AT_RANDOM provides 16 random bytes which can be used to seed
> + * userspace PRNGs at program load time.
> + */
> +#define ELF_AUXV_RANDOM_SIZE 16
> +#endif

No, this cannot be changeable because there is no way for userland to
find out the size.  And no, don't reintroduce the the extra aux vector
entry.  Just define it to 16 and that's it.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkjmWWQACgkQ2ijCOnn/RHTbUACfU7i4DImOYXiFNxPa7m7HWiMX
4iQAoLk+7r0bVPGSrjAUcwW701oeDKlJ
=y+Ci
-----END PGP SIGNATURE-----
