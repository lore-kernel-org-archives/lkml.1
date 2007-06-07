Return-Path: <linux-kernel-owner+w=401wt.eu-S935352AbXFGS5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935352AbXFGS5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 14:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932745AbXFGS5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 14:57:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932687AbXFGS5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 14:57:03 -0400
Message-ID: <466854CE.8010504@redhat.com>
Date: Thu, 07 Jun 2007 11:56:14 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7> <20070606235906.72439d16@the-village.bc.nu> <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com> <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu> <4668155B.4020705@redhat.com> <20070607195659.c695c87d.dada1@cosmosbay.com> <46684DED.6000907@redhat.com> <Pine.LNX.4.64.0706071132130.6445@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0706071132130.6445@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Davide Libenzi wrote:
>> And to add to your list:
>>
>> epoll_create().  Important if you think that's the interface people
>> should use.
> 
> Can't we leave it as is, and use sys_nonseqfd() for those? So basically:

The problem is O_CLOEXEC.  They are all racy and if we add a variant
with flags then we might as well support O_NONSEQFD as well.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGaFTO2ijCOnn/RHQRAm7uAJ9NsP6FegpO3cAnCe83eZ8awtkHawCgzKK4
2OjiNCFJhviQSMOaKHS6cTI=
=v9jU
-----END PGP SIGNATURE-----
