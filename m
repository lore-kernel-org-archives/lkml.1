Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbXCNBDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbXCNBDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 21:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXCNBDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 21:03:33 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:37269 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbXCNBDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 21:03:33 -0400
Subject: Re: [RFC/PATCH 00/59] Make common x86 arch area for i386 and x86_64
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0703131432400.9690@woody.linux-foundation.org>
References: <1173820919.28042.3.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703131432400.9690@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 21:02:15 -0400
Message-Id: <1173834135.30118.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 14:39 -0700, Linus Torvalds wrote:
> 
> On Tue, 13 Mar 2007, Steven Rostedt wrote:
> > 
> > What we have currently is a bunch of hacks.  Seems that people can't make
> > up their mind to what to do.
> 
> I don't mind the patches, but I'd be a lot happier if it also was a stated 
> intention to actually make it be buildable as "x86", the same way that the 
> separate 32-bit and 64-bit POWER architectures were merged into just one 
> architecture that could be built either way.

That's actually a larger goal, but for the immediate future, I figure
this would be a good first step.  Start out by stating what's similar,
and then build off of this for something bigger.  But in the mean time,
we can have a staging ground for work that's for both i386 and x86_64
archs. And for those that know these systems in a more intimate way
(Andi :) they can work off of this to make that monster.

-- Steve

