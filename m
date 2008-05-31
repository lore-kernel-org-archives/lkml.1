Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbYEaDTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbYEaDTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 23:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYEaDSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 23:18:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbYEaDSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 23:18:53 -0400
Message-ID: <4840C394.2080807@redhat.com>
Date: Fri, 30 May 2008 20:18:44 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 3/3] 64-bit futexes: x86 support
References: <200805310127.m4V1RLdP013819@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301923020.3141@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805301923020.3141@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> Also, doesn't this mean that effectively you have given up on any CPU 
> before the Pentium entirely? 

Yes, but only for the speed-up.  Not for the functionality.  All
programs will work just fine.


> Not that I want to take the patches _anyway_, but it seems doubly stupid. 
> Those things are going to be UP machines, so you could have just emulated 
> it with no correctness issues by disabling preemption.

First, you're thinking too much in kernel terms.  At userlevel I cannot
disable interrupts etc.  I cannot read 64 bits atomically on those
processors.  Second, the old implementation is not significantly slower
in normal programs on UP machines.  It's really not a big issue.


In any case, robbing 64-bit architectures of the possible performance
gain just because there are ancient versions which cannot do it is just
plain stupid.  I know you cannot suggest that.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhAw5QACgkQ2ijCOnn/RHTRRwCgv37woIjA5RJji4XamBQVqCyF
VMwAoIauSEdAlfK4pBJhMkIKirwEBw0z
=rDJc
-----END PGP SIGNATURE-----
