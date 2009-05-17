Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbZEQU77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbZEQU77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 16:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbZEQU7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 16:59:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:52391 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbZEQU7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 16:59:47 -0400
Date: Sun, 17 May 2009 13:59:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
Message-ID: <20090517135940.42cb30a0@infradead.org>
In-Reply-To: <20090513094728.59d10898@gondolin>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com>
	<20090512154456.GC6255@nowhere>
	<20090512160434.GD6255@nowhere>
	<20090512183105.09e628f0@gondolin>
	<20090512165227.GE6255@nowhere>
	<20090512191848.25764af6@gondolin>
	<d82e647a0905121728m278b604bn9a0f5122b964978a@mail.gmail.com>
	<20090513012011.GA32518@nowhere>
	<20090513094728.59d10898@gondolin>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 09:47:28 +0200
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> On Wed, 13 May 2009 03:20:13 +0200,
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Wed, May 13, 2009 at 08:28:15AM +0800, Ming Lei wrote:
> 
> > > Also we still allow async_schedule*()  to run a job synchronously
> > > if out of memory
> > > or other failure. This can keep consistency with before.
> > 
> > 
> > Yes, but also most of the current users of async_schedule() could
> > call it with GFP_KERNEL. For now it's not an issue because it is
> > not widely used, but who knows how that will evolve...
> 
> Well, if we want to change the interface, now would be a good time
> since there are still few callers.

I would prefer it that if we make a more complex interface, we keep the
current simple interface as a wrapper, so that the simple case can
remain simple.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
