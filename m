Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZJLKNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZJLKNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZJLKNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:13:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867AbZJLKNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:13:17 -0400
Date: Mon, 12 Oct 2009 12:11:51 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       David Airlie <airlied@linux.ie>, Jonathan Corbet <corbet@lwn.net>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Vincent Sanders <vince@simtec.co.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH RFC] frontend.c: Remove the BKL from agp_open
In-Reply-To: <21d7e9970910120203k3b411796pf00e3453c4d2297b@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0910121209140.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910112216060.12574@localhost.localdomain> <21d7e9970910120203k3b411796pf00e3453c4d2297b@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Oct 2009, Dave Airlie wrote:

> On Mon, Oct 12, 2009 at 6:24 AM, John Kacur <jkacur@redhat.com> wrote:
> >
> > @David Airlie. I was looking at the agp driver for removal of the bkl
> > lock. From what I could tell, the mutex_lock(&(agp_fe.agp_mutex)) should
> > cover what we need. However, I may have easily missed something, and would
> > appreciate your review / comments on the patch.
> 
> This seems fine, though I suck at locking logic,
> 
> One thing to note is the number of users of this interface is probably
> close to 0,
> so even if this does break something we probably won't ever find out.
> 
> Dave.
> 

Hmnn, you are listed as the maintainer - don't at least YOU use this 
driver? Also, if it seem fine to you, can I have an ack?

Thanks
