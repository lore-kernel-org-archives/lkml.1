Return-Path: <linux-kernel-owner+w=401wt.eu-S1750738AbXCORWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750738AbXCORWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 13:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXCORWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 13:22:34 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:59888 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXCORWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 13:22:33 -0400
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
	Take 2
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
In-Reply-To: <20070315170112.GA14759@one.firstfloor.org>
References: <20070314050819.536207642@goodmis.org>
	 <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu>
	 <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
	 <45F96B57.10206@mbligh.org>
	 <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
	 <20070315160648.GA11812@one.firstfloor.org>
	 <1173977264.7922.24.camel@localhost.localdomain>
	 <1173977839.7922.27.camel@localhost.localdomain>
	 <20070315170112.GA14759@one.firstfloor.org>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 13:21:21 -0400
Message-Id: <1173979281.7922.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 18:01 +0100, Andi Kleen wrote:
> > Oops, sorry, you did say "in the includes".  Yeah, that holds the same
> > crap that I'm talking about. 
> 
> It's a simple and obvious solution that does exactly what it is 
> supposed to do. Why do you call it crap? 

Yes, it's a simple solution. The reason I called it crap was because it
does what the other hacks do. It hides from the developer a dependency
that can create bugs in the other arch, and is not IMNSHO clean.

When one works on one arch, you should not need to be worried about
breaking other archs when you stay within the arch/ and asm-<arch>
directories.

-- Steve


