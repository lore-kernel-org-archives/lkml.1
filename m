Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYJGAJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYJGAJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYJGAJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:09:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60879 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbYJGAJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:09:13 -0400
Message-ID: <48EAA87B.6000402@redhat.com>
Date: Mon, 06 Oct 2008 17:08:27 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Kees Cook <kees.cook@canonical.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Jakub Jelinek <jakub@redhat.com>,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
References: <20081001201116.GD12527@outflux.net>	<48E3EFD6.2010704@redhat.com>	<20081001215657.GH12527@outflux.net>	<20081001220948.GC32107@sunsite.ms.mff.cuni.cz>	<20081001222706.68E7E1544B4@magilla.localdomain>	<20081003001616.GN10632@outflux.net>	<87ej2untze.fsf@basil.nowhere.org>	<20081006175038.GF10357@outflux.net>	<20081006192641.GI3180@one.firstfloor.org>	<20081006220759.GM10357@outflux.net> <20081006235827.59306154271@magilla.localdomain>
In-Reply-To: <20081006235827.59306154271@magilla.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Roland McGrath wrote:
> What glibc wants is some bits with a strength of randomness chosen by the
> kernel, and not to worry about the details.  I think the strength applied
> to mmap and stack randomization is good enough for AT_RANDOM.

I think the decision about the pool should be hidden behind some
interface.  I agree, the AT_RANDOM data and ASLR can live with the same
type of data.

But perhaps we can make the interface a bid more complex for SUID and
uid==0 binaries.

Also, for platforms with cheap random data sources (VIA Padlock,
hopefully more in future).

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjqqHsACgkQ2ijCOnn/RHRRVgCeIQDpaol6HXgTdzpGcQKn40lp
ZX4An1HBITlkN/hRHe1Cqy8/QUuZ7ZyX
=nQuu
-----END PGP SIGNATURE-----
