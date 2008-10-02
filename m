Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbYJBAgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbYJBAgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 20:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYJBAgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 20:36:33 -0400
Received: from ozlabs.org ([203.10.76.45]:38893 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYJBAgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 20:36:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 01/31] cpumask: Documentation
Date: Thu, 2 Oct 2008 10:36:27 +1000
User-Agent: KMail/1.9.9
Cc: Mike Travis <travis@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
References: <20080929180250.111209000@polaris-admin.engr.sgi.com> <200810010849.46874.rusty@rustcorp.com.au> <20081001091325.GA12503@elte.hu>
In-Reply-To: <20081001091325.GA12503@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810021036.29054.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2008 19:13:25 Ingo Molnar wrote:
> that looks very sane to me.

Thanks, it's reasonably nice.  The task of hitting all those cpumask_t users 
is big, and I don't think we can do it in one hit.

> one small request:
> > I'll commit these to my quilt series today.
>
> IMHO, an infrastructure change of this magnitude should absolutely be
> done via the Git space. This needs a ton of testing and needs bisection,
> a real Git track record, etc.

Not yet.  Committing untested patches into git is the enemy of bisection; if 
one of my patches breaks an architecture, they lose the ability to bisect 
until its fixed.  If it's a series of patches, we can go back and fix it.

Now, once it's been tested a little, it's better for you to git-ize it and 
I'll send you patches instead.  But I want some more people banging on it, 
and a run through linux-next first...

If Mike's happy to work on these as a basis, we should be able to get there 
soon; the patches are sitting in my tree at http://ozlabs.org/~rusty/kernel/ 
(see rr-latest symlink).

Thanks,
Rusty.
PS.  To emphasize, I haven't actually *booted* this kernel.  My test machines 
are still in transit as I move (and ADSL not connected yet... Grr...)
