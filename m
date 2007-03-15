Return-Path: <linux-kernel-owner+w=401wt.eu-S1422950AbXCOQYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422950AbXCOQYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422956AbXCOQYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:24:42 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58721 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422950AbXCOQYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:24:41 -0400
Date: Thu, 15 Mar 2007 09:23:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Martin Bligh <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <20070315160648.GA11812@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0703150919021.3816@woody.linux-foundation.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
 <45F96B57.10206@mbligh.org> <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
 <20070315160648.GA11812@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Mar 2007, Andi Kleen wrote:

> > That's *exactly* what the patches do (except it's called "arch/x86", which 
> > is clearly the best option - please don't use "ia" _anywhere_ except for 
> > "ia64", since that's the only architecture that is really "intel 
> > architecture").
> 
> And i860 @)

Yeah, well (and the i960).. I don't think it's very likely that we'll ever 
support that in the kernel ;)

(There are others. i432 is the really *classic* intel architecture. It was 
such a spectacular failure that it's still remembered today, even though 
it was never actually used).

> Well I just see a lot of pain from these patches but I doubt 
> they will avoid any bugs. If people don't compile test both
> archs they will always likely break on another. There are lots
> of subtle dependencies that are not expressed in the pathname
> even after this intrusive operation (e.g. in the includes).

Well, we'veliterally had bugs because people who modified i386 files 
didn't even *realize* that they were also used on x86-64. 

I do agree that we'd need to look at do the same thing for include files, 
for the same reason. 

			Linus
