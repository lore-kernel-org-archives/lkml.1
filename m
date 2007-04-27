Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbXD0VVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbXD0VVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbXD0VVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:21:20 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:23636 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322AbXD0VVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:21:18 -0400
Date: Fri, 27 Apr 2007 14:22:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: [GIT-PULL] please pull UBI tree
Message-Id: <20070427142254.3aa89a16.randy.dunlap@oracle.com>
In-Reply-To: <20070427135224.58d54065.akpm@linux-foundation.org>
References: <1177677925.7539.18.camel@sauron>
	<alpine.LFD.0.98.0704270855300.9964@woody.linux-foundation.org>
	<20070427135224.58d54065.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 13:52:24 -0700 Andrew Morton wrote:

> On Fri, 27 Apr 2007 09:00:25 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Fri, 27 Apr 2007, Artem Bityutskiy wrote:
> > >
> > > Linus, please, pull UBI tree from
> > > git://git.infradead.org/ubi-2.6.git for-linus
> > > 
> > > The UBI tree has been in -mm for several releases and we would like to
> > > see it in the mainline.
> > 
> > Quite frankly, I have absolutely _zero_ visibility into things like this, 
> > so before I merge it I want ack's from various layers (preferably a 
> > mixture of interests - are any vendors interested, is DavidW ok with this, 
> > who is using it now and are the interfaces and designs correct etc etc?)
> > 
> > So I simply cannot make that decision. I don't have the expertise or the 
> > knowledge. I'll have to trust somebody else for things like this, and it 
> > should be somebody who isn't "personally involved". 
> > 
> > In other words, I kind of want a sign-off from other parties, because I 
> > can't pull things like this "blind".
> > 
> > Are there (embedded?) vendors that already integrate this into their 
> > kernel, or wait for it? Is dwmw supportive of this? Questions, questions..
> 
> The patchset used to contain lots of debugging support which wildly
> duplicated thigs which we already did and was generally overdone.  That
> appears to all have been cleaned up now, so thanks for doing that.
> 
> The one remaining nit I'd have with the debug code is that it adds a
> private hexdump() facility.  By my count, that is the kernel's eighth
> hexdump implementation.  There may be even more which don't have "hexdump"
> in their name.
> 
> lib/hexdump.c is rather overdue.

I have a version of that from James Ketrenos that I have been working
on...  Can post in a few days.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
