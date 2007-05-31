Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbXEaUXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbXEaUXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbXEaUXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:23:31 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4140 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbXEaUXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:23:30 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 31 May 2007 13:23:29 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Jakub Jelinek <jakub@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
In-Reply-To: <465F270B.5090604@redhat.com>
Message-ID: <Pine.LNX.4.64.0705311320310.30485@alien.or.mcafeemobile.com>
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0705311123370.30485@alien.or.mcafeemobile.com>
 <465F170B.3070603@redhat.com> <Pine.LNX.4.64.0705311144290.30485@alien.or.mcafeemobile.com>
 <20070531190235.GY4033@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0705311205520.30485@alien.or.mcafeemobile.com>
 <465F270B.5090604@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Ulrich Drepper wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Davide Libenzi wrote:
> > What I meant, was that the vast majority of MT+exec 
> > apps wants all their fds (but an handfull, maybe)
> 
> You never listen when you are told something.  Such a statement cannot
> be made.  The application doesn't know what the runtime libraries need
> (not just libc, libstdc++, libxml, whatever) and vice versa.  Policies
> are always wrong for somebody and changing the standardized behavior is
> not acceptable.

I do always listen when you make a good point. And this is a good one. 
Some libraries might not like a global behaviour change, I agree.



- Davide


