Return-Path: <linux-kernel-owner+w=401wt.eu-S1765545AbYBVTUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765545AbYBVTUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758696AbYBVTUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:20:43 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36383 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185AbYBVTUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:20:42 -0500
Message-ID: <47BF206C.8040001@garzik.org>
Date: Fri, 22 Feb 2008 14:20:12 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Merging of completely unreviewed drivers
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <20080222185359.GA29945@elte.hu>
In-Reply-To: <20080222185359.GA29945@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>  2) you might know that Deja-Vu moment when you look at a new patch that 
>     has been submitted to lkml and you have a strange, weird "feeling" 
>     that there's something wrong about the patch.
> 
>     It's totally subconscious, and you take a closer look and a few
>     seconds later you find a real bug in the code.
> 
>     That "feeling" i believe comes from a fundamental property of how 
>     human vision is connected to the human brain: pattern matching. 
>     Really good programmers have built a "library" of patterns of "good" 
>     and "bad" looking coding practices.
> 
>     If a patch or if a file has a clean _style_, bugs and deeper 
>     structural problems often stand out like a sore thumb. But if the 
[...]

>     The best programmers are the ones who have a good eye for details - 
>     and that subconsciously extends to "style details" too. I've yet to
>     see a _single_ example of a good, experienced kernel programmer who 
>     writes code that looks absolutely careless and sloppy, but which is 
>     top-notch otherwise. (Newbies will make style mistakes a lot more 
>     often - and for them checkpatch is a nice and easy experience at 
>     reading other people's code and trying to learn the style of the 
>     kernel.)
[...]

>  4) there's a psychological effect as well: clean _looking_ code is 
>     more attractive to coders to improve upon. Once the code _looks_ 
>     clean (mechanically), the people with the real structural cleanups 
>     are not far away either. Code that just looks nice is simply more of 
>     a pleasure to work with and to improve, so there's a strong 
>     psychological relationship between the "small, seemingly unimportant 
>     details" cleanups and the real, structural cleanups.

The above deserved to be quoted...  just because I agree with all of it 
so strongly :)

Bugs really do "hide" in ugly code, in part because my brain has been 
optimized to review clean code.

Like everything else in life, one must strike a balance between picking 
style nits with someone's patch, and making honest criticisms of a patch 
because said patch is too "unclean" to be reviewed by anyone.

	Jeff



