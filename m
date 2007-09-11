Return-Path: <linux-kernel-owner+w=401wt.eu-S1761003AbXIKVwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003AbXIKVwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbXIKVwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:52:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756769AbXIKVwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:52:07 -0400
Date: Tue, 11 Sep 2007 14:51:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
In-Reply-To: <200709112234.24155.ak@suse.de>
Message-ID: <alpine.LFD.0.999.0709111448520.16478@woody.linux-foundation.org>
References: <20070911201219.GA9674@uranus.ravnborg.org> <200709112138.11247.ak@suse.de>
 <20070911211422.GU3563@stusta.de> <200709112234.24155.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 Sep 2007, Andi Kleen wrote:
> 
> Will that cause people to compile test both? I have my doubts that 
> will really work.

If people don't compile-test both now, then why would they compile-test 
things when merged?

So no, that's not the point.

But at least things like "grep" will work sanely, and people will be 
*aware* that "Oh, this touches a file that may be used by the other 
word-size".

Right now, we have people changing "i386-only" files that turn out to be 
used by x86-64 too - through very subtle Makefile things that the person 
who only looks into the i386 Makefile will never even *see*.

THAT is the problem (well, at least part of it).

		Linus
