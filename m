Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbXK0Rl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbXK0Rl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 12:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbXK0Rlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 12:41:46 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:54529 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756781AbXK0Rlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 12:41:45 -0500
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
From: Tom Tucker <tom@opengridcomputing.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Roland Dreier <rdreier@cisco.com>,
       Andi Kleen <ak@suse.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
In-Reply-To: <20071127171542.GB3406@stusta.de>
References: <20071122343.446909000@suse.de>
	 <200711261228.15155.rusty@rustcorp.com.au> <adahcj9sfan.fsf@cisco.com>
	 <200711271549.37670.rusty@rustcorp.com.au>
	 <1196141742.9876.49.camel@trinity.ogc.int>
	 <20071127171542.GB3406@stusta.de>
Content-Type: text/plain
Organization: Open Grid Computing, Inc.
Date: Tue, 27 Nov 2007 11:45:37 -0600
Message-Id: <1196185537.24469.21.camel@trinity.ogc.int>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-11-27 at 18:15 +0100, Adrian Bunk wrote:
> On Mon, Nov 26, 2007 at 11:35:42PM -0600, Tom Tucker wrote:
> > On Tue, 2007-11-27 at 15:49 +1100, Rusty Russell wrote:
> >...
> > > No.  That's the wrong question.  What's the real upside?
> > 
> > Explicitly documenting what comprises the kernel API (external,
> > supported) and what comprises the kernel implementation (internal, not
> > supported).
> >...
> 
> There is not, never was, and never will be, any supported external API 
> of the kernel.

Philosophically I understand what you're saying, but in practical terms
there is the issue of managing core API like kmalloc. Although kmalloc
_could_ change, doing so would be extremely painful. In fact anyone who
proposed such a change would have to have a profoundly powerful argument
as to why it was necessary.

I think this patchset is an attempt to make it easier to identify and
review these kinds of interfaces.

>  
> cu
> Adrian
> 

