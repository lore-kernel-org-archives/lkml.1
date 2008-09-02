Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbYIBSNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbYIBSNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 14:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYIBSNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 14:13:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbYIBSNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 14:13:16 -0400
Date: Tue, 2 Sep 2008 11:12:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Sanders <linux@sandersweb.net>
cc: linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <200809020808.23131.linux@sandersweb.net>
Message-ID: <alpine.LFD.1.10.0809021109330.3210@nehalem.linux-foundation.org>
References: <200808311422.12525.linux@sandersweb.net> <200809011623.12518.linux@sandersweb.net> <alpine.LFD.1.10.0809011521270.12958@nehalem.linux-foundation.org> <200809020808.23131.linux@sandersweb.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Sep 2008, David Sanders wrote:
>
> I reverted the commit and the problem persits, so nops are definitely not the 
> problem.  I started an new bisection but am now in a state that won't compile 
> due to errors.  What do I do in that case?

You can try "git bisect skip", but in general the better choice is to just 
do

	git bisect visualize

to open up gitk with the current set of possible targets, and then just 
pick a likely point by hand, and do

	git reset --hard <sha1-of-the-thing-you-picked>

and try that one instead. There's some talk about this in "man git-bisect"
but maybe it's not very good.

			Linus
