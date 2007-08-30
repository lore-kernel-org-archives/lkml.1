Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbXH3Cq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbXH3Cq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 22:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXH3Cqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 22:46:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbXH3Cqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 22:46:46 -0400
Message-ID: <46D62F8A.6010303@redhat.com>
Date: Wed, 29 Aug 2007 19:46:34 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Valdis.Kletnieks@vt.edu, jakub@redhat.com, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc3-mm1 - vdso and gettimeofday issues with glibc
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>	<23252.1188396273@turing-police.cc.vt.edu>	<3909.1188409058@turing-police.cc.vt.edu> <20070829161545.9fde1a5c.akpm@linux-foundation.org>
In-Reply-To: <20070829161545.9fde1a5c.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> So it's an interaction between the x86_64 vdso patches in Andi's tree and 
> newer glibc, and we don't know which one is getting it wrong yet?

glibc does nothing but call the code in the vdso.  We have a function
pointer variable which either has the old vsyscall value or the address
of the function in the vdso.  Everything else is identical.  Unless the
interface of the vdso function is different (which it shouldn't) I don't
think you can blame glibc.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG1i+K2ijCOnn/RHQRArogAKC3zBeyOzqJRF+x2zj3fBg9iGLdyQCgx9Z3
dv3Izh65+kxKedza6RH3MHk=
=qEdC
-----END PGP SIGNATURE-----
