Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYELQiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYELQiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 12:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYELQiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 12:38:09 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59016 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbYELQiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 12:38:07 -0400
Subject: Re: oprofile BUG() in current kernel.
From: Chris J Arges <arges@linux.vnet.ibm.com>
Reply-To: arges@linux.vnet.ibm.com
To: Maynard Johnson <maynardj@us.ibm.com>
Cc: Gianni Tedesco <gxt@cs.nott.ac.uk>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       oprofile-list@lists.sourceforge.net, Mike Travis <travis@sgi.com>
In-Reply-To: <48285002.9080702@us.ibm.com>
References: <1210593756.3708.7.camel@dao.KWGR614>
	 <19f34abd0805120519t12fceef9u7870006a904c85b2@mail.gmail.com>
	 <1210599105.3479.1.camel@dao.KWGR614>  <48285002.9080702@us.ibm.com>
Content-Type: text/plain
Organization: IBM
Date: Mon, 12 May 2008 11:38:03 -0500
Message-Id: <1210610283.7218.4.camel@snuffleupagus>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me know if this change is going to be reverted, as I have a patch
ready to support cpu hotplug for oprofile based on code post
DEFINE_PER_CPU patch. 
Thanks,

On Mon, 2008-05-12 at 09:11 -0500, Maynard Johnson wrote:
> Gianni Tedesco wrote:
> > On Mon, 2008-05-12 at 14:19 +0200, Vegard Nossum wrote:
> >   
> >> Hi,
> >>
> >> On Mon, May 12, 2008 at 2:02 PM, Gianni Tedesco <gxt@cs.nott.ac.uk> wrote:
> >>     
> >>> This is from Linus' git tree, pulled this morning. To reproduce simply
> >>>  opcontrol --start
> >>>
> >>>  oprofile: using NMI interrupt.
> >>>  BUG: unable to handle kernel paging request at eff86d58
> >>>  IP: [<eeb9d508>] :oprofile:alloc_cpu_buffers+0x42/0xd6
> >>>
> >>>       
> >> This looks similar to:
> >>
> >> http://www.uwsg.iu.edu/hypermail/linux/kernel/0805.0/2845.html
> >>     
> >
> > Yes, remarkably similar ;)
> >
> >   
> >> Does reverting 608dfddd845da5ab6accef70154c8910529699f7 fix it for you too?
> >>     
> Has this fix been officially reverted?
> >
> > It does indeed. Thanks for the pointer.
> >
> >
> > -------------------------------------------------------------------------
> > This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
> > Don't miss this year's exciting event. There's still time to save $100. 
> > Use priority code J8TL2D2. 
> > http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
> > _______________________________________________
> > oprofile-list mailing list
> > oprofile-list@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/oprofile-list
> >   
> 
> 
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
> Don't miss this year's exciting event. There's still time to save $100. 
> Use priority code J8TL2D2. 
> http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
> _______________________________________________
> oprofile-list mailing list
> oprofile-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/oprofile-list
-- 
Chris J Arges
Software Engineer
IBM Linux Technology Center
Austin, TX
arges@linux.vnet.ibm.com

