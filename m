Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYEEFD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYEEFD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 01:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYEEFDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 01:03:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbYEEFDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 01:03:13 -0400
Message-ID: <481E9455.7030704@redhat.com>
Date: Sun, 04 May 2008 22:00:05 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?UTF-8?B?WU9TSElGVUpJIEhpZGVha2kgLyDlkInol6Toi7HmmI4=?= 
	<yoshfuji@linux-ipv6.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, davidel@xmailserver.org,
       mtk.manpages@gmail.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 02/18] flag parameters: socket and socketpair
References: <200805050342.m453gktl029817@devserv.devel.redhat.com> <20080505.132452.98853465.yoshfuji@linux-ipv6.org>
In-Reply-To: <20080505.132452.98853465.yoshfuji@linux-ipv6.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

YOSHIFUJI Hideaki / 吉藤英明 wrote:

> To me, it seems overriding 2nd argument is a too ad-hoc workaround,
> and introducing new syscalls with flags is cleaner, e.g.,
>     psocket(family, socktype, protocol, flags);
>     psocketpair(d, type, protocol, int sv[2], flags);

While I agree, you missed the initial discussion where Alan, DaveM, and
Linus expressed preference for this overloading.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkgelFUACgkQ2ijCOnn/RHSt1ACgx5ksBu0jMDqZDcG01PmJ4Jel
EywAoKLQ8pEKcB+bY+vDzaOaZvLyPag0
=6iYM
-----END PGP SIGNATURE-----
