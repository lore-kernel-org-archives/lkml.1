Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYHMPXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYHMPXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYHMPXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:23:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYHMPXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:23:23 -0400
Message-ID: <48A2FC17.9070302@redhat.com>
Date: Wed, 13 Aug 2008 08:21:59 -0700
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
References: <af8810200808121736q76640cc1kb814385072fe9b29@mail.gmail.com> <af8810200808121745h596c175bk348d0aaeeb9bcb45@mail.gmail.com> <20080813104445.GA24632@elte.hu> <20080813063533.444c650d@infradead.org> <48A2EE07.3040003@redhat.com> <20080813142529.GB21129@elte.hu> <48A2F157.7000303@redhat.com> <20080813151007.GA8780@elte.hu>
In-Reply-To: <20080813151007.GA8780@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ingo Molnar wrote:
> i find it pretty unacceptable these days that we limit any aspect of 
> pure 64-bit apps in any way to 4GB (or any other 32-bit-ish limit). 

Sure, but if we can pin-point the sub-archs for which it is the problem
then a flag to optionally request it is even easier to handle.  You'd
simply ignore the flag for anything but the P4 architecture.

I personally have no problem removing the whole thing because I have no
such machine running anymore.  But there are people out there who have.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkii/BcACgkQ2ijCOnn/RHQ8FACfZFV+WaBmS6UNqZZ/xDfV/Z7z
gIAAoJSmbauchdaIVIebz8N2rPrszAMF
=WAzJ
-----END PGP SIGNATURE-----
