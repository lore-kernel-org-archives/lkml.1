Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbYHMOg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbYHMOg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYHMOgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:36:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYHMOgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:36:47 -0400
Message-ID: <48A2F157.7000303@redhat.com>
Date: Wed, 13 Aug 2008 07:36:07 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       hugh@veritas.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       briangrant@google.com, cgd@google.com, mbligh@google.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: pthread_create() slow for many threads; also time to revisit
 64b context switch optimization?
References: <af8810200808121736q76640cc1kb814385072fe9b29@mail.gmail.com> <af8810200808121745h596c175bk348d0aaeeb9bcb45@mail.gmail.com> <20080813104445.GA24632@elte.hu> <20080813063533.444c650d@infradead.org> <48A2EE07.3040003@redhat.com> <20080813142529.GB21129@elte.hu>
In-Reply-To: <20080813142529.GB21129@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ingo Molnar wrote:
> not sure exactly what numbers you mean, but there are lots of numbers in 
> the first mail, attached below. For example:

I mean numbers indicating that it doesn't hurt performance on any of
today's machines.  If there are machines where it makes a difference
then we need the flag to indicate the _preference_ for a low stack, as
opposed to indicating a _requirement_.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkii8VcACgkQ2ijCOnn/RHTiLQCfcZ9xJHMi0Jv59l700ZNJUoi6
aEcAn370XuGhs1u1YeD2Gqq35zQnKh26
=rC0v
-----END PGP SIGNATURE-----
