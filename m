Return-Path: <linux-kernel-owner+w=401wt.eu-S1761418AbXEaSyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418AbXEaSyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbXEaSyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:54:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111AbXEaSyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:54:38 -0400
Message-ID: <465F19BF.80005@redhat.com>
Date: Thu, 31 May 2007 11:53:51 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com> <Pine.LNX.4.64.0705311123370.30485@alien.or.mcafeemobile.com> <465F170B.3070603@redhat.com> <Pine.LNX.4.64.0705311144290.30485@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0705311144290.30485@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/31/2007 Davide Libenzi wrote:
> I was talking for a broader usage, not only glibc centric. Most ppl 
> writing MT+exec apps wants all but (eventually) and handfull of files 
> leaking across the exec boundary.

Policies are not the answer.  Using such a flag is no big issue.  *Iff*
we should end up with some form of private file descriptors changing the
default for them would be OK, too.  But the existing semantics mustn't
be touched, even if it is selectable.  Trying to fix existing buggy code
this way is foolish since it might just as well break assumptions in the
same program.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGXxm/2ijCOnn/RHQRAm+wAJ9YD6KsS6T96xChZvS/3yCwCo6+0gCgl0IY
y6OxxUcuQ8yGJsiYebkuIMY=
=tkxV
-----END PGP SIGNATURE-----
