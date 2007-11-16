Return-Path: <linux-kernel-owner+w=401wt.eu-S1761171AbXKPSUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761171AbXKPSUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXKPST7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:19:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbXKPST6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:19:58 -0500
Message-ID: <473DDF1B.5030706@redhat.com>
Date: Fri, 16 Nov 2007 10:19:07 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: dean gaudet <dean@arctic.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv2 4/4] first use of sys_indirect system call
References: <200711151822.lAFIMVnJ028596@devserv.devel.redhat.com> <alpine.DEB.0.9999.0711161003310.15441@twinlark.arctic.org>
In-Reply-To: <alpine.DEB.0.9999.0711161003310.15441@twinlark.arctic.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

dean gaudet wrote:
> honestly i think there should be a per-task flag which indicates whether 
> fds are by default F_CLOEXEC or not.  my reason:  third party libraries.

Only somebody who thinks exclusively about applications as opposed to
runtimes/libraries can say something like that.  Library writers don't
have the luxury of being able to modify any global state.  This has all
been discussed here before.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHPd8b2ijCOnn/RHQRAuPPAKCm5mcOl8dycDenxi7BNFdrf2IfWgCgmaXQ
Fj7V13HU1vX6fM9bRumxRpk=
=UIi1
-----END PGP SIGNATURE-----
