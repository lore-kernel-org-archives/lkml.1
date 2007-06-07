Return-Path: <linux-kernel-owner+w=401wt.eu-S933898AbXFGUFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbXFGUFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbXFGUFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:05:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53324 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245AbXFGUFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:05:36 -0400
Date: Thu, 7 Jun 2007 13:03:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-Id: <20070607130319.8fd96e03.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706071132130.6445@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
	<20070606235906.72439d16@the-village.bc.nu>
	<Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
	<20070607001932.35c9591c@the-village.bc.nu>
	<466741BD.20106@redhat.com>
	<20070607110432.73be7960@the-village.bc.nu>
	<4668155B.4020705@redhat.com>
	<20070607195659.c695c87d.dada1@cosmosbay.com>
	<46684DED.6000907@redhat.com>
	<Pine.LNX.4.64.0706071132130.6445@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 11:39:39 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> On Thu, 7 Jun 2007, Ulrich Drepper wrote:
> 
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > Eric Dumazet wrote:
> > > eventfd2(int count, int oflags);
> > > 
> > > signalfd2(int ufd, sigset_t __user *user_mask, size_t sizemask, int oflags);
> > > 
> > > timerfd2(int ufd, int clockid, int flags,const struct itimerspec __user *utmr, int oflags) ...
> > 
> > These aren't released yet, so, change them now before it's too late.
> 
> Linus, Andrew, would it be OK to change?

Absolutely.  Let's get them into their final form now, rather than letting
some intermediate interface escape out into a major kernel release.

<directs attention to
ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/fix-eventd-syscall>
