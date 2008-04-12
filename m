Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYDLFKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYDLFKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 01:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYDLFKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 01:10:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070AbYDLFKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 01:10:20 -0400
Date: Fri, 11 Apr 2008 22:09:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [DOC PATCH] semaphore documentation
Message-Id: <20080411220911.3e7ab3e4.akpm@linux-foundation.org>
In-Reply-To: <20080411132754.b1c1fd8f.randy.dunlap@oracle.com>
References: <20080410143403.c03757e5.akpm@linux-foundation.org>
	<20080410220816.GY11962@parisc-linux.org>
	<20080410151907.91f11c74.akpm@linux-foundation.org>
	<20080411192153.GH11962@parisc-linux.org>
	<20080411132754.b1c1fd8f.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 13:27:54 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Fri, 11 Apr 2008 13:21:54 -0600 Matthew Wilcox wrote:
> 
> > On Thu, Apr 10, 2008 at 03:19:07PM -0700, Andrew Morton wrote:
> > > On Thu, 10 Apr 2008 16:08:16 -0600
> > > Matthew Wilcox <matthew@wil.cx> wrote:
> > > > It seems very strange to me to document the API with the implementation
> > > > rather than with the declaration.  It's almost as if we expect people to
> > > > have to read the implementation to figure out how stuff works.
> > > 
> > > That approach makes sense for C++.  But for C, the code is .c-centric.
> > 
> > I've never programmed in C++ ... I just expect to find API documentation
> > in header files.
> > 
> > > That's particularly the case with the kernel, where we explicitly work to
> > > make the .c files the things which people look at, while not caring about
> > > the .h files.  Look at how much we say "get that ifdef out of there and
> > > hide it in the header file".
> > 
> > I see that as being "move the complexity around" and "get the interfaces
> > right", not "hide it in the header files where nobody ever looks".
> > 
> > > > How about a note in semaphore.c that says "refer to semaphore.h for
> > > > usage information"?
> > > 
> > > No, please document it in the C file, where people expect to find it.
> > 
> > Fine, I've done it the other way round.
> > 
> > Please review this doc-patch.  Without comments, I'll commit it to the
> > semaphore git tree tomorrow.
> 
> Looks good to me.  Thanks.

Yup, most excellent.

btw, down() and friends should have might_sleep() checks in them, shouldn't
they?  They don't seem to be in there, nor in mainline
lib/semaphore-sleepers.c.  Confused.

