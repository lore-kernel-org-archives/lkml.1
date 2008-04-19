Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYDSQlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYDSQlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 12:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYDSQln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 12:41:43 -0400
Received: from ozlabs.org ([203.10.76.45]:36802 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbYDSQlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 12:41:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael Kerrisk" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 2/5] /dev/vring: simple userspace-kernel ringbuffer interface.
Date: Sun, 20 Apr 2008 02:41:14 +1000
User-Agent: KMail/1.9.9
Cc: "Andrew Morton" <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <200804181433.48488.rusty@rustcorp.com.au> <20080418115959.6b8fdfa7.akpm@linux-foundation.org> <517f3f820804181238s79326d10tf898691f997715e5@mail.gmail.com>
In-Reply-To: <517f3f820804181238s79326d10tf898691f997715e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804200241.14722.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 April 2008 05:38:50 Michael Kerrisk wrote:
> On 4/18/08, Andrew Morton <akpm@linux-foundation.org> wrote:
> > This is may be our third high-bandwidth user/kernel interface to
> > transport bulk data ("hbukittbd") which was implemented because its
> > predecessors weren't quite right.  In a year or two's time someone else
> > will need a hbukittbd and will find that the existing three aren't quite
> > right and will give us another one.  One day we need to stop doing this
> > ;)

If only there were some kind of, I don't know... summit... for kernel 
people... 

> >  It could be that this person will look at Rusty's hbukittbd and find
> > that it _could_ be tweaked to do what he wants, but it's already shipping
> > and it's part of the kernel API and hence can't be made to do what he
> > wants.

Indeed.  I marked it experimental because of these questions (ie. it's not yet 
kernel ABI).  Getting everyone's attention is hard tho, so I figured we put 
it in as a device and moving to a syscall if and when we feel it's ready.

> >  So I think it would be good to plonk the proposed interface on the table
> >  and have a poke at it.  Is it compat-safe?  Is it extensible in a
> >  backward-compatible fashion?  Are there future-safe changes we should
> > make to it?  Can Michael Kerrisk understand, review and document it? 
> > etc.
>
> Well, it helps if he's CCed....

It is compat safe, and we've already extended it once, so I'm reasonably happy 
so far.  If it were a syscall I'd add a flags arg, for the device it'd be an 
ioctl.  Starting with the virtio ABI seemed a reasonable first step, because 
*we* can use this today even if noone else does.

> I'm happy to work *with someone* on the documentation (pointless to do
> it on my own -- how do I know what Rusty's *intended* behavior for the
> interface is), and review, and testing.

Document coming up...
Rusty.
