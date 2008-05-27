Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYE0Ljh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYE0Ljh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 07:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbYE0Lj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 07:39:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43454 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYE0Lj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 07:39:27 -0400
Date: Tue, 27 May 2008 13:40:14 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@linux.intel.com>,
       Jan Kara <jack@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080527114014.GA16868@elf.ucw.cz>
References: <4836EE8C.1010200@linux.intel.com> <20080524222304.GD20563@atrey.karlin.mff.cuni.cz> <20080524153020.1df96cf2@linux.intel.com> <20080524224554.GA5970@mit.edu> <20080526093913.GG13529@elte.hu> <20080526101646.GD24507@mit.edu> <20080526104832.GG23261@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526104832.GG23261@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-05-26 12:48:32, Ingo Molnar wrote:
> 
> * Theodore Tso <tytso@MIT.EDU> wrote:
> 
> > On Mon, May 26, 2008 at 11:39:13AM +0200, Ingo Molnar wrote:
> > > Exactly why is pulling an USB stick considered "stupid"? Last i checked 
> > > there was no physical lock preventing users from doing that.
> > > 
> > > Sure, pulling a mounted USB stick is inconvenient ... for _us_ 
> > > kernel developers. But the user really doesnt care and shouldnt 
> > > care.
> > 
> > Because they could lose data?  Because if the kernel wakes up and 
> > tries writing to the USB stick right as they pull it out, it could 
> > physically damage the flash format?  I know, stupid reason...  :-)
> 
> user can lose data in many other ways, that's not the issue - the issue 
> here is something very crutial: the kernel gets confused about a _very_ 
> common user-triggerable condition.
> 
> That confusion must not happen in a modern OS and the kernel should be 
> resilient and cope with such external events. And we must not 
> deprioritize it with an incorrect "user did something stupid" tag... 

Of course unavoidable "data corruption happens when user pulls the
stick without unmounting" has lower priority than, for example "usb
stick stops working randomly when used overnight"?

And we have still bugs of the second class, so yes unexpected pulls do
have lower priority.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
