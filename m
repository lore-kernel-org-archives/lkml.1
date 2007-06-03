Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbXFCXCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbXFCXCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 19:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXFCXBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 19:01:54 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3079 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbXFCXBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 19:01:53 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 3 Jun 2007 16:01:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] ufd v1 - use unsequential O(1) fdmap
In-Reply-To: <4663289D.5030109@redhat.com>
Message-ID: <Pine.LNX.4.64.0706031601150.13247@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825146.2>
 <4663067C.9050002@redhat.com> <Pine.LNX.4.64.0706031127220.13247@alien.or.mcafeemobile.com>
 <466319DB.80800@redhat.com> <Pine.LNX.4.64.0706031311490.13247@alien.or.mcafeemobile.com>
 <4663289D.5030109@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007, Ulrich Drepper wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Davide Libenzi wrote:
> >> If randomizing each allocator is too expensive then randomize at the
> >> very least the number of the first descriptor you give out.
> > 
> > Can you tell me how this can be a problem, and in which way making a 
> > random thing would help?
> 
> In attacking an application every bit of known data can be used in an
> exploit.  Be it something as simple as having a predetermined value at a
> certain point in the program since it loaded a file descriptor into a
> register.
> 
> But what I'm mostly thinking about is the case where I/O could be
> redirected.  The intruding program could call dup2() and suddenly the
> program wanting to write a password to disk could be directed to send it
> over a socket.  One could imagine countless such attacks.
> 
> I don't say such an attack exists today.  But this is no reason to not
> implement these extra security measures.  The cost of a randomized star
> base (offset from 2^30) should be zero.

Randomizing the base is not a problem. Should this be always, or flag 
driven?



- Davide


