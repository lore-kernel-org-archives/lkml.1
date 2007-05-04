Return-Path: <linux-kernel-owner+w=401wt.eu-S1031353AbXEDHrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031353AbXEDHrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031356AbXEDHrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:47:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:11528 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031353AbXEDHrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:47:06 -0400
Date: Fri, 4 May 2007 00:43:34 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, wli@holomorphy.com
Subject: Re: [2/6] add config option to vmalloc stacks (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070504074334.GL26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Christoph Hellwig <hch@infradead.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
	Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174310.GE19966@holomorphy.com> <20070504053529.GA3245@nineveh.rivenstone.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504053529.GA3245@nineveh.rivenstone.net>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:43:10AM -0700, William Lee Irwin III wrote:
>> +	  Allocates the stack physically discontiguously and from high
>> +	  memory. Furthermore an unmapped guard page follows the stack.
>> +	  This is not for end-users. It's intended to trigger fatal
>> +	  system errors under various forms of stack abuse.

On Fri, May 04, 2007 at 01:35:30AM -0400, Joseph Fannin wrote:
>     Why is this not for end-users?  Will it not trigger anything
> useful unless set up properly, or is a big performace hit -- and how,
> or what?
>     All the kernel debug options are underdocumented this way -- I'd
> like to have as many of them on as I can without absolutely killing
> performance, (or rather, *you* would) -- but I can never tell without
> grovelling all over for the info, which... well, I haven't done it
> yet, anyway.

There aren't many effective sideband methods to document things. If I
knew of an "expanded help" thing people could look at in Kconfig, I'd
write storybook documentation and put it there as I'm wont to do.


On Fri, May 04, 2007 at 01:35:30AM -0400, Joseph Fannin wrote:
>     "End-user" is just insufficently defined for anyone compiling
> their own kernel.  Could you add a bit more text here describing what
> the effect of physically discontiguous high-memory stacks is?  An
> additional frobnitz dereference on every badda-bing badda-bang, likely
> to double the time it takes to dance the hokey pokey?
>    *shrug*  Some of those debug options probably don't get set very
> often on kernels that are run for more than to see if it boots.

It's short for "whoever doesn't understand the terse jargon" as I'm
using it. The assumption here is that it's essentially for kernel
hackers who know all about kernel internals up-front anyway.

The option really is not to be trifled with. Maybe I could work with the
kerneldoc developers to arrange for outlets for more verbose
documentation for options (actually I'd like similar for API functions
as well; I'd like to write IRIX-style roman fleuve manpages for things).
There is a slight danger, though, that the documentation may get out of
synch. For now, I just have nowhere appropriate to put it.


-- wli
