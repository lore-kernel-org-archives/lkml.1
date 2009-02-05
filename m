Return-Path: <linux-kernel-owner+w=401wt.eu-S1760538AbZBEADW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760538AbZBEADW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZBEADI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:03:08 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:33735 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbZBEADG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:03:06 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 4 Feb 2009 16:02:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: mtk.manpages@gmail.com
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-api@vger.kernel.org
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
In-Reply-To: <cfd18e0f0902041559l4c40d9b6k704068337a00df7a@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0902041600170.6214@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>  <20090204150507.665b5b7c.akpm@linux-foundation.org>  <alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com>  <20090204152434.c8f65d52.akpm@linux-foundation.org> 
 <alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com>  <20090204155514.6abbdc8f.akpm@linux-foundation.org> <cfd18e0f0902041559l4c40d9b6k704068337a00df7a@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009, Michael Kerrisk wrote:

> > Dunno.  Probably try the syscall and see if it returned -EINVAL.  Does
> > that work in this case?
> 
> As youll have seen by now, Ulrich and I noted that it works.
> 
> > If so, it would be sensible to mention this in
> > the description somewhere as the approved probing method and to
> > maintain it.
> 
> I'll add something to the man page, as this patch progresses.

I see we already have stuff like this inside the man pages:

O_CLOEXEC (Since Linux 2.6.23)
          Enable the close-on-exec flag for the new file descriptor.  
          ...

Maybe a similar note for the new flag?



- Davide


