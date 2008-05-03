Return-Path: <linux-kernel-owner+w=401wt.eu-S1762886AbYECP6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762886AbYECP6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 11:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757747AbYECP63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 11:58:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512AbYECP63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 11:58:29 -0400
Message-ID: <481C8B48.5020306@redhat.com>
Date: Sat, 03 May 2008 08:56:56 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: John Williams <john.williams@petalogix.com>, monstr@seznam.cz,
       Matthew Wilcox <matthew@wil.cx>, Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
Subject: Re: microblaze syscall list
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <481ACE51.80202@seznam.cz> <481BE0E4.7010904@petalogix.com> <200805031116.50236.arnd@arndb.de>
In-Reply-To: <200805031116.50236.arnd@arndb.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Arnd Bergmann wrote:
> Uli: The question at hand is what syscalls a new linux architecture
> should implement. To take utimes() as an example, the kernel currently
> has utime(), utimes(), futimesat() and utimensat(), while glibc
> provides utime(), utimes(), futimes(), futimesat(), futimens() and
> utimensat(). In theory, all the glibc interfaces could be provided
> on top of the utimensat() syscall, but should they?

Yes, this is how it should be.  It's not done because no architecture
glibc officially supports arrived after these and similar syscalls
arrived.  There is no need to implement the not-*at interface, no need
to implement the creat syscall, etc etc.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIHItI2ijCOnn/RHQRAm+9AJ4zGHVzNxgt9Zbrf0Uj27n4AQH6LACfVpIC
qYnU0uBg3he4hKx0cujQQ7U=
=ozRC
-----END PGP SIGNATURE-----
