Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbYJ1EXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbYJ1EXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 00:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbYJ1EXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 00:23:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44662 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbYJ1EXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 00:23:08 -0400
Message-ID: <490693A3.9070805@redhat.com>
Date: Mon, 27 Oct 2008 21:22:59 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH] reintroduce accept4
References: <200810261641.m9QGfotr024285@hs20-bc2-1.build.redhat.com> <20081027204135.a139704e.akpm@linux-foundation.org>
In-Reply-To: <20081027204135.a139704e.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> I'll confess to not having a clue what's going on here.

It has been discussed at length.  accept created file descriptors and we
need flags for tis.

>> #elif __i386__
>> #define SYS_ACCEPT4     18
>> #define USE_SOCKETCALL 1
>> #define SOCK_CLOEXEC O_CLOEXEC
>> #else
> 
> Well.  This doesn't actually agree with the kernel patch.

What doesn't agree?


> I'd suggest that i386 is sufficiently common to warrant its inclusion
> in the initial patch.

The x86 code is included.  x86 uses socketcall instead of a syscall.

I changed all paccept occurrences in the tree, not just x86-64.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkkGk6MACgkQ2ijCOnn/RHSwSgCfeb/PGDCm2qy0ZESqWb8wgyhX
cHoAoIIXvhBjdxcj2gy09eQBzNKOTwCU
=QSFh
-----END PGP SIGNATURE-----
