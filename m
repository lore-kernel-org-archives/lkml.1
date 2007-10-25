Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbXJYOzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbXJYOzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbXJYOzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:55:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757251AbXJYOzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:55:06 -0400
Date: Thu, 25 Oct 2007 07:55:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Kleen, Andi" <ak@suse.de>
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <200710251324.49888.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.0.999.0710250744420.30120@woody.linux-foundation.org>
References: <200710251324.49888.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Oct 2007, Nick Piggin wrote:
> 
> Andi spotted this exchange on the gcc list. I don't think he's
> brought it up here yet, but it worries me enough that I'd like
> to discuss it.

Are you surprised?

The gcc developers seem to have had a total disregard for what people 
want or need, and every time some code generation issue comes up, there's 
a lot of people on the list that do language-lawyering, rather than admit 
that there might be a problem.

It's happened before, it will happen again. I don't think it's true of all 
gcc developers (or even most, I hope), but it's common enough. For some 
reason, compiler developers seem to be far enough removed from "real life" 
that they have a tendency to talk in terms of "this is what the spec says" 
rather than "this is a problem".

Happily, at least in this kind of situation, threading is a real issue for 
other projects than just the kernel, so maybe it gets solved properly.

But I have to admit that for the last five years or so, I've really wanted 
some other compiler team to come up with a good open-source compiler. 
Exactly due to issues like this (Q: "Gcc creates bogus code that doesn't 
work!" A: "It's not bogus, it's technically allowed by the language specs 
that don't talk about xyz, the fact that it doesn't work isn't our 
problem").

I think the OpenBSD people decided to actually do something about this, 
and I suspect it had *nothing* to do with license issues, and everything 
to do with these kinds of problems. I wish them all the luck, although 
personally I think LLVM is a much more interesting project.

			Linus
