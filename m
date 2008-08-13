Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbYHMO2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbYHMO2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYHMO2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:28:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbYHMO2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:28:12 -0400
Message-ID: <48A2EE07.3040003@redhat.com>
Date: Wed, 13 Aug 2008 07:21:59 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, hugh@veritas.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, briangrant@google.com,
       cgd@google.com, mbligh@google.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: pthread_create() slow for many threads; also time to revisit
 64b context switch optimization?
References: <af8810200808121736q76640cc1kb814385072fe9b29@mail.gmail.com>	<af8810200808121745h596c175bk348d0aaeeb9bcb45@mail.gmail.com>	<20080813104445.GA24632@elte.hu> <20080813063533.444c650d@infradead.org>
In-Reply-To: <20080813063533.444c650d@infradead.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Arjan van de Ven wrote:
>> i'd go for 1) or 2).
> 
> I would go for 1) clearly; it's the cleanest thing going forward for
> sure.

I want to see numbers first.  If there are problems visible I definitely
would want to see 2.  Andi at the time I wrote that code was very
adamant that I use the flag.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkii7gcACgkQ2ijCOnn/RHTveQCeIefB1R5QpuQ71RNMihKL5oWD
ZVoAnjjjKgXznRx8qtbrF+fgvcNwsngA
=dAz2
-----END PGP SIGNATURE-----
