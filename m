Return-Path: <linux-kernel-owner+w=401wt.eu-S1764080AbYBVTqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764080AbYBVTqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbYBVTqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:46:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42807 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYBVTqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:46:31 -0500
Date: Fri, 22 Feb 2008 11:44:59 -0800
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080222194459.GA21250@kroah.com>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <20080222185359.GA29945@elte.hu> <47BF206C.8040001@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BF206C.8040001@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 02:20:12PM -0500, Jeff Garzik wrote:
> Ingo Molnar wrote:
>>  2) you might know that Deja-Vu moment when you look at a new patch that   
>>   has been submitted to lkml and you have a strange, weird "feeling"     
>> that there's something wrong about the patch.
>>     It's totally subconscious, and you take a closer look and a few
>>     seconds later you find a real bug in the code.
>>     That "feeling" i believe comes from a fundamental property of how     
>> human vision is connected to the human brain: pattern matching.     Really 
>> good programmers have built a "library" of patterns of "good"     and 
>> "bad" looking coding practices.
>>     If a patch or if a file has a clean _style_, bugs and deeper     
>> structural problems often stand out like a sore thumb. But if the 
> [...]
>
>>     The best programmers are the ones who have a good eye for details -    
>>  and that subconsciously extends to "style details" too. I've yet to
>>     see a _single_ example of a good, experienced kernel programmer who    
>>  writes code that looks absolutely careless and sloppy, but which is     
>> top-notch otherwise. (Newbies will make style mistakes a lot more     
>> often - and for them checkpatch is a nice and easy experience at     
>> reading other people's code and trying to learn the style of the     
>> kernel.)
> [...]
>
>>  4) there's a psychological effect as well: clean _looking_ code is     
>> more attractive to coders to improve upon. Once the code _looks_     clean 
>> (mechanically), the people with the real structural cleanups     are not 
>> far away either. Code that just looks nice is simply more of     a 
>> pleasure to work with and to improve, so there's a strong     
>> psychological relationship between the "small, seemingly unimportant     
>> details" cleanups and the real, structural cleanups.
>
> The above deserved to be quoted...  just because I agree with all of it so 
> strongly :)
>
> Bugs really do "hide" in ugly code, in part because my brain has been 
> optimized to review clean code.
>
> Like everything else in life, one must strike a balance between picking 
> style nits with someone's patch, and making honest criticisms of a patch 
> because said patch is too "unclean" to be reviewed by anyone.

I totally agree with all of this.  checkpatch.pl is a useful tool to
use, and is quite handy for helping the kernel code for all of the above
reasons.

</aol>

thanks,

greg k-h
