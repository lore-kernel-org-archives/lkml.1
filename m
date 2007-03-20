Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbXCTGMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbXCTGMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 02:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbXCTGMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 02:12:44 -0400
Received: from 1wt.eu ([62.212.114.60]:1278 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbXCTGMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 02:12:32 -0400
Date: Tue, 20 Mar 2007 07:11:52 +0100
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Xavier Bestel <xavier.bestel@free.fr>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RSDL v0.31
Message-ID: <20070320061152.GW943@1wt.eu>
References: <200703042335.26785.a1426z@gawab.com> <200703172048.46267.kernel@kolivas.org> <1174125534.7734.2.camel@Homer.simpson.net> <200703172355.30989.a1426z@gawab.com> <45FEB54A.3040602@rtr.ca> <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca> <1174322580.30876.72.camel@frg-rhel40-em64t-04> <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 08:11:55PM -0700, Linus Torvalds wrote:
> Quite frankly, I was *planning* on merging RSDL very early after 2.6.21, 
> but there is one thing that has turned me completely off the whole thing:
> 
>  - the people involved seem to be totally unwilling to even admit there 
>    might be a problem.
> 
> This is like alcoholism. If you cannot admit that you might have a 
> problem, you'll never get anywhere. And quite frankly, the RSDL proponents 
> seem to be in denial ("we're always better", "it's your problem if the old 
> scheduler works better", "just one report of old scheduler being better").
> 
> And the thing is, if people aren't even _willing_ to admit that there may 
> be issues, there's *no*way*in*hell* I will merge it even for testing. 
> Because the whole and only point of merging RSDL was to see if it could 
> replace the old scheduler, and the most important feature in that case is 
> not whether it is perfect, BUT WHETHER ANYBODY IS INTERESTED IN TRYING TO 
> FIX THE INEVITABLE PROBLEMS!

Linus, you're unfair with Con. He initially was on this position, and lately
worked with Mike by proposing changes to try to improve his X responsiveness.
But he's ill right now and cannot touch the keyboard, so only his supporters
speak for him, and as you know, speech is not code and does not fix problems.

Leave him a week or so to relieve and let's see what he can propose. Hopefully
a week away from the keyboard will help him think with a more general approach.
Also, Mike has already modified the code a bit to get better experience.

Also, while I don't agree with starting to renice X to get something usable,
it seems real that there's something funny on Mike's system which makes it
behave particularly strangely when combined with RSDL, because other people
in comparable tests (including me) have found X perfectly smooth even with
loads in the tens or even hundreds. I really suspect that we will find a bug
in RSDL which triggers the problem and that this fix will help discover
another problem on Mike's hardware which was not triggered by mainline.

Regards,
Willy

