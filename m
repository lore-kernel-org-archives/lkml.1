Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYHMSFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYHMSFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYHMSFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:05:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbYHMSFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:05:36 -0400
Message-ID: <48A3222D.2060809@redhat.com>
Date: Wed, 13 Aug 2008 11:04:29 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       akpm@linux-foundation.org, hugh@veritas.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, briangrant@google.com, cgd@google.com,
       mbligh@google.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: pthread_create() slow for many threads; also time to revisit
 64b context switch optimization?
References: <af8810200808121736q76640cc1kb814385072fe9b29@mail.gmail.com> <af8810200808121745h596c175bk348d0aaeeb9bcb45@mail.gmail.com> <20080813104445.GA24632@elte.hu> <20080813063533.444c650d@infradead.org> <48A2EE07.3040003@redhat.com> <20080813142529.GB21129@elte.hu> <48A2F157.7000303@redhat.com> <20080813151007.GA8780@elte.hu> <48A2FC17.9070302@redhat.com> <20080813154043.GA11886@elte.hu> <48A303EE.8070002@redhat.com> <alpine.LFD.1.10.0808131007530.3462@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808131007530.3462@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> Ulrich, I don't understand why you worry more about a _potential_ (and 
> fairly unlikely) complaint, than about a real one today.

Of course I care.  All I try to do is to prevent going from one extreme
(all focus on P4s) to the other (ignore P4s completely).

Even ignoring this one case here, I think it's in any case useful for
userlevel to tell the kernel that an anonymous memory region is needed
for a stack.  This might allow better optimizations and/or security
implementations.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkijIi0ACgkQ2ijCOnn/RHRqCwCcCAeJw+BzO9MSwKRtemm5VAq3
FBYAoKbMwR1pkthjLvNlpCSVS76CCoAq
=UfmJ
-----END PGP SIGNATURE-----
