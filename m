Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbXG1NSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbXG1NSY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 09:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbXG1NSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 09:18:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:48615 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbXG1NSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 09:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lHTZU8gQbHOMpsiqU05qVteCSH8AUF3qUZKN9juX3vgXUIRhXf0qG+7tJDgbldYoPYvycaMshtDVqTWNQlMNfYROG/uls0law7H96knLo7Fi5r9HfxfNI+AlpAIvNkWnghl01lF0VlXVPh/O6fAnhSXdkAtLwVLhJXNsBVd+ZIE=
Message-ID: <b14e81f00707280618m73461fdfx989d87a3a0074192@mail.gmail.com>
Date: Sat, 28 Jul 2007 09:18:14 -0400
From: "Michael Chang" <thenewme91@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Cc: "Kasper Sandberg" <lkml@metanurb.dk>,
       "CK Mailinglist" <ck@vds.kolivas.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185588279.1654.1.camel@localhost>
	 <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Con ended up arguing against people who reported problems, rather than
> trying to work with them.

I do recall there is one issue on which Con wouldn't budge -- anything
that involved boosting certain kinds of processes in the kernel. He
said that it would defeat the whole point of the way he had designed
it, and that nicing could work just as well. Perhaps there could have
been a better way of handling that issue, such as adding (yet another)
kernel compilation configuration option for this code (since Con
didn't believe it would help all users).

> Andrew also reported an oops in the scheduler when SD was merged into -mm,
> so there were other issues.

I don't know how you can blame Con for not finding a PPC oops before
SD was merged into -mm, considering he seemed to be coding solely on
an x86-based architecture. Of course, you could say that his design
should have factored in all the architectures and such, but even the
best design can fall apart if it doesn't get tested somewhere. Again,
this is probably a subjective case in that Con might have pushed SD to
-mm rather early; but considering the readership of his -ck list, I
don't think it would have been tested on anything other than X86 until
it went into -mm because I've ever seen anyone on -ck report "it works
on <something other than x86/x86-64/IA64>". I don't know what made it
on to other lists, but Con tried his best to fix this oops, and unless
it was done privately, this oops was never re-reported. (Now, if SD
was _STILL_ causing this oops on PPC, I can see how this might be a
concern.)

> > As far as im concerned, i may be forced to unofficially maintain SD for
> > my own systems(allthough lots in the gaming community is bound to be
> > interrested, as it does make games lots better)
>
> You know what? You can do whatever you want to. That's kind of the point
> of open source. Keep people honest by having alternatives.
>
> But the the thing is, if you want to do a good job of doing that, here's a
> big hint: instead of keeping to your isolated world, instead of just
> talking about your own machine and ignoring other peoples machines and
> issues and instead of just denying that problems may exist, and instead of
> attacking people who report problems, how about working with them?
>
> That was where the SD patches fell down. They didn't have a maintainer
> that I could trust to actually care about any other issues than his own.

So if we found a better maintainer who would commit to maintaining the
SD patches, would you still be willing to consider merging them? Is
this what you're saying?

> I'm happy that SD was perfect for you. It wasn't for others, and it had
> nobody who was even interested in trying to solve those issues.

-- 
Michael Chang

Please avoid sending me Word or PowerPoint attachments. Send me ODT,
RTF, or HTML instead.
See http://www.gnu.org/philosophy/no-word-attachments.html
Thank you.
