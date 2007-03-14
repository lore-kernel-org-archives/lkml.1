Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbXCNAwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbXCNAwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 20:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbXCNAwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 20:52:54 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:57546 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbXCNAwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 20:52:53 -0400
Subject: Re: [RFC/PATCH 06/59] mv kernel/acpi/processor.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <Pine.LNX.4.64.0703131429260.9690@woody.linux-foundation.org>
References: <20070313204458.531339803@goodmis.org>
	 <1173820977.28042.13.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703131429260.9690@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 20:51:37 -0400
Message-Id: <1173833497.30118.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 14:32 -0700, Linus Torvalds wrote:
> 
> On Tue, 13 Mar 2007, Steven Rostedt wrote:
> >
> > Move kernel/acpi/processor.c to the common hold.
> 
> Please use
> 
> 	git diff -M

OK, thanks!  I'm still quite a git-nubie.

I'll update all the move patches. It may take a bit of hand work.

What I really did to do this patch series was to make all my changes in
git.  But the changes where not smooth from change set to change set. So
I did one big git-diff, and then used good old midnight commander (mc)
to parse the patches. And then pulled them into quilt to comment and
send them.


> 
> for things like this.
> 
> In fact, even if you weren't a git user, I'd ask you to *become* one just 
> because I think that it's a *lot* more productive if people actually see 
> renames as renames, and will see what - if anything - changed when 
> renaming.
> 
> The "-M" flag isn't the default, simply because it generates patches that 
> cannot be applied with regular "patch", but for something like this, I 
> think it's practically imperative. The old kind of "remove file" + "add 
> file" patch just isn't acceptable when there are very viable alternaties.

I wish I knew this before breaking it up.   But I'm sure I can do
another big patch and automate these updates :)

-- Steve


