Return-Path: <linux-kernel-owner+w=401wt.eu-S1761051AbXEaSnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051AbXEaSnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbXEaSnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:43:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbXEaSnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:43:08 -0400
Message-ID: <465F170B.3070603@redhat.com>
Date: Thu, 31 May 2007 11:42:19 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com> <Pine.LNX.4.64.0705311123370.30485@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0705311123370.30485@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Davide Libenzi wrote:
> Isn't this better be a global process flag? Default should be, for legacy
> reasons,

No.  Policies are always wrong since it means code that cannot change
the policy (e.g, all runtime libraries) have no access to the
functionality.  I cannot set the policy to default to close-on-exit in
glibc all the while the application assumes this is not the case.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGXxcK2ijCOnn/RHQRAmM9AKC5BEIEBsgwhWx09aAMA0CwsesMWQCfScGr
vCF+Ih1lDP5rliY8D2Om5vU=
=ZShC
-----END PGP SIGNATURE-----
