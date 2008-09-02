Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYIBSof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYIBSof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 14:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYIBSoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 14:44:24 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:18297 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbYIBSoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 14:44:22 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Date: Tue, 2 Sep 2008 14:44:15 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi-suse@firstfloor.org>
References: <200808311422.12525.linux@sandersweb.net> <200809020808.23131.linux@sandersweb.net> <alpine.LFD.1.10.0809021109330.3210@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809021109330.3210@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809021444.17153.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 September 2008 14:12, Linus Torvalds wrote:
> On Tue, 2 Sep 2008, David Sanders wrote:
> > I reverted the commit and the problem persits, so nops are definitely not
> > the problem.  I started an new bisection but am now in a state that won't
> > compile due to errors.  What do I do in that case?
>
> You can try "git bisect skip", but in general the better choice is to just
> do
>
> 	git bisect visualize
>
> to open up gitk with the current set of possible targets, and then just
> pick a likely point by hand, and do
>
> 	git reset --hard <sha1-of-the-thing-you-picked>
>
> and try that one instead. There's some talk about this in "man git-bisect"
> but maybe it's not very good.
>
> 			Linus

OK thanks, I had to build a new version of git because the one installed with 
my distribution was too old to have git bisect skip.  I am trying to use the 
gitk method you mentioned but it is going slow and on my screen gitk's fonts 
are very hard to read.
David
