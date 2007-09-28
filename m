Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbXI1SYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbXI1SYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbXI1SX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:23:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbXI1SX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:23:58 -0400
Message-ID: <46FD46B4.9050401@redhat.com>
Date: Fri, 28 Sep 2007 11:23:48 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: F_DUPFD_CLOEXEC implementation
References: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com> <Pine.LNX.4.64.0709281113390.22521@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0709281113390.22521@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Davide Libenzi wrote:
> I think new system calls would have been a cleaner way to accomplish this. 
> The "small pill at a time" may have better chance to go in, but will 
> likely result in an uglier userspace interface.

We'd need this call anyway since neither dup nor dup2 provides the
functionality of F_DUPFD (but F_DUPFD can be used to implement dup).

For dup2() I will wait until we have a sys_indirect implementation.
I'll try to get this soon.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG/Ua02ijCOnn/RHQRAgOQAKCfQ9H4VYau6nVGuVXyJ7IfBXK+QgCfYQxv
k4esG379v8VBceFIECDybk0=
=dvhX
-----END PGP SIGNATURE-----
