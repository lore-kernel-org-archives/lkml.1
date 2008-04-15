Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbYDOGsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbYDOGsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYDOGsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:48:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39149 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbYDOGsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:48:01 -0400
Subject: Re: [PATCH] Replace completions with semaphores
From: Peter Zijlstra <peterz@infradead.org>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com>
References: <20080411210022.GJ11962@parisc-linux.org>
	 <20080412204748.GN11962@parisc-linux.org> <20080413070833.GC19773@elte.hu>
	 <20080413125758.GQ11962@parisc-linux.org> <20080414153928.GA22259@elte.hu>
	 <adafxtoqvgh.fsf@cisco.com> <1208190749.7375.10.camel@twins>
	 <87d4osuy6r.fsf@basil.nowhere.org> <1208195673.7164.2.camel@twins>
	 <4803AD91.5020001@firstfloor.org>
	 <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 08:46:56 +0200
Message-Id: <1208242017.7053.4.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-15 at 08:18 +0200, Bart Van Assche wrote:
> On Mon, Apr 14, 2008 at 9:16 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >  For me it sounds like you just want to rename semaphores to some other
> >  name that people don't use them for normal locking?
> 
> Would it really be a good idea to give a synchronization concept that
> behaves exactly like a semaphore another name than "semaphore" ? The
> semaphore concept is well known and is taught in every computer
> science course.

Are the ramifications wrt priority inversion taught? Is it made clear
that its hard to validate because there is no clear resource owner?

Afaik, non of these subjects are touched upon in the CS-101 courses and
that is exactly the problem. So you can say they are not well know, they
are just widely misunderstood.

And yes, if there are more hand a very few such users it doesn't make
sense to keep them open coded.

