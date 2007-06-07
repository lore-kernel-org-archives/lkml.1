Return-Path: <linux-kernel-owner+w=401wt.eu-S935021AbXFGS1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935021AbXFGS1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 14:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761572AbXFGS1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 14:27:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761027AbXFGS1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 14:27:46 -0400
Message-ID: <46684DED.6000907@redhat.com>
Date: Thu, 07 Jun 2007 11:26:53 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>	<20070606235906.72439d16@the-village.bc.nu>	<Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>	<20070607001932.35c9591c@the-village.bc.nu>	<466741BD.20106@redhat.com>	<20070607110432.73be7960@the-village.bc.nu>	<4668155B.4020705@redhat.com> <20070607195659.c695c87d.dada1@cosmosbay.com>
In-Reply-To: <20070607195659.c695c87d.dada1@cosmosbay.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Eric Dumazet wrote:
> eventfd2(int count, int oflags);
> 
> signalfd2(int ufd, sigset_t __user *user_mask, size_t sizemask, int oflags);
> 
> timerfd2(int ufd, int clockid, int flags,const struct itimerspec __user *utmr, int oflags) ...

These aren't released yet, so, change them now before it's too late.

And to add to your list:

epoll_create().  Important if you think that's the interface people
should use.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGaE3t2ijCOnn/RHQRAqPGAJ4rhSxvWLvAseBTCZIywIpQ7JCTJACfZSdR
fGkbIAX5l/1zISYQ6rLmIrk=
=Ge8V
-----END PGP SIGNATURE-----
