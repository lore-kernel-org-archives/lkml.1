Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbXEKOib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbXEKOib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 10:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbXEKOiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 10:38:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35336 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754297AbXEKOiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 10:38:24 -0400
Date: Fri, 11 May 2007 15:40:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, bunk@stusta.de,
       randy.dunlap@oracle.com, akpm@linux-foundation.org,
       rpjday@mindspring.com, marcel@holtmann.org, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module_author: don't advice putting in an email address
Message-ID: <20070511154009.50c8bae0@the-village.bc.nu>
In-Reply-To: <46447ABF.3000004@gmail.com>
References: <4643BDF2.9030105@gmail.com>
	<20070511114605.4c2698ec@the-village.bc.nu>
	<46447ABF.3000004@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Whether someone puts their email address into the entry is their own
> > business. We do not need a style police for module author entries.
> 
> This particular patch just deletes the _advice_ to add an address; if you'd 
> consider it a style issue, you shouldn't be objecting.

We should merely advise that the address be reliable and long term
> 
> But it's not a style issue. It's solving a problem. The adresses from this 
> tag are the only addresses available from the binary and as such are 
> mistaken for maintainer/general contact addresses which they often are not.

Which is why you want MODULE_MAINTAINER()

> contacted for the driver. Giving that MODULE_MAINTAINER was concluded to not 
> be a good idea

Not my fault, not my problem, take it back up with the objectors

> Then the next issue is email addresses getting outdated. I've had my share 
> of bug reports both bounce and not bounce but just not getting any reply and 
> I can assure you it's the kind of frustrating experience that makes you just 
> stop trying. From source and/or MAINTAINERS file they can be deleted but 
> they can't ofcourse from the binary installs on user machines. Even the 
> person listed can't do that, which is issue 3.

The source tree on the users box has the same problem. The author also
can't update the kernel rpm packages provided by the distibutor where
99.99% of the users get their data.

> You earlier objected to removing the MODULE_AUTHOR tag outright on legal 
> grounds but you yourself are one of the people using only a name and not an 
> address in the tag. In fact, most of the core contributors are, so I assume 
> you don't have that same objection again.

I have no problem with people using name only, or name and email. Its
not my problem what they use.

> My specific angle is old PC hardware where the drivers have outlived their 
> authors (various ISA junk, legacy CD-ROM, what have you) where I or some 
> other newbie might want to take on maintainership of a driver. I can add 
> myself to MAINTAINERS but not to binary installs, and in fact even on a 
> source level the addresses from the MODULE_AUTHOR tag confuse the issue of 
> who's responsibe for the thing.

You can update the current tree in both cases. You can update neither
source nor binary of an existing release. Your argument is bogus.

> This specific problem of mine would be solved by me just deleting the 
> addresses from the specific drivers I'm interested in and just not bothering 
> with anything else. This means the problems outlined above would just live 
> on for everything else though and we happily continue to frustrate bug 
> reporters and maintainers.

You can also solve the problem of bugs in drivers by deleting the driver.
Both are equivalent neither are very smart.

If you find a bogus maintainer entry email then update/remove it. That
way the housekeeping gets done.

> Finally, at the very, very least the advice to add more future problems 
> should be killed and that's the only thing _this_ particular patch does.

Adding new drivers causes future problems, lets stop that too ?

Email addresses in modules are often useful as well - they have utility
just like a new driver does. You don't get one without the other.

Alan
