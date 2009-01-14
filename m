Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbZANA62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbZANA62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZANA6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:58:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471AbZANA6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:58:17 -0500
Date: Tue, 13 Jan 2009 16:57:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: mtk.manpages@gmail.com
cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
Subject: Re: [PATCH] sys_waitid: return -EFAULT for NULL
In-Reply-To: <cfd18e0f0901131653y76a827b5i906fadce63ada56b@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0901131655040.6528@localhost.localdomain>
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>  <cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>  <20090113224759.7DFB7FC3DD@magilla.sf.frob.com>  <20090113224941.36F19FC3DD@magilla.sf.frob.com> 
 <alpine.LFD.2.00.0901131629220.6528@localhost.localdomain> <cfd18e0f0901131653y76a827b5i906fadce63ada56b@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Jan 2009, Michael Kerrisk wrote:
> 
> It has zero downside for *us*.  But it is yet another example of Linux
> littering the Unix landscape with unnecessary inconsistencies that
> application writers must deal with.

Bah. Not so. It matters not at all if you try to write portable code. 

Linux has extensions. Deal with it. We have literally _thousands_ of 
things that work on Linux but not on other OS's. The fact is, you can't 
just recompile and assume something works, and waitid() has absolutely 
nothing to do with it.

> Well, POSIX.1-2001 is fairly clear:
> 
>       The  application shall ensure that the infop argument points to
>       a siginfo_t structure.

Right. So the application should do that, and Linux does the right thing. 
Problem solved.

			Linus
