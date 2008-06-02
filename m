Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYFBGXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYFBGXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYFBGWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:22:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110AbYFBGWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:22:54 -0400
Date: Sun, 1 Jun 2008 23:22:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: Re: Diagnosing linux-next (Was: Re: m68k libc5 regression)
Message-Id: <20080601232215.e87aafd0.akpm@linux-foundation.org>
In-Reply-To: <18499.35335.408967.918602@cargo.ozlabs.ibm.com>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
	<Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
	<20080601005338.3affe880.akpm@linux-foundation.org>
	<20080601232638.fda1f3ab.sfr@canb.auug.org.au>
	<20080601140415.a2f25b9d.akpm@linux-foundation.org>
	<18499.16693.526974.912404@cargo.ozlabs.ibm.com>
	<20080601180616.75d1886e.akpm@linux-foundation.org>
	<18499.22285.159342.856006@cargo.ozlabs.ibm.com>
	<20080601223758.627e96e8.akpm@linux-foundation.org>
	<18499.35335.408967.918602@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008 15:49:59 +1000 Paul Mackerras <paulus@samba.org> wrote:

> Andrew Morton writes:
> 
> > On Mon, 2 Jun 2008 12:12:29 +1000 Paul Mackerras <paulus@samba.org> wrote:
> > > There's now a facility for viewing diffs in an external viewer.  If
> > > you do Edit->Preferences and set the "External diff tool" thing to
> > > tkdiff, then you can right-click on a file name in the file list
> > > (bottom right-hand pane) and select "External diff" and it will launch
> > > tkdiff to show you the diffs for that file.
> > 
> > <upgrades>
> > 
> > OK, that works, thanks.  Right-clicking on each file is the sole way to
> > bring it up?
> 
> At the moment, yes.  Do you want something different?

No, that's OK.

> > > What is it you like about tkdiff?  Is it the side-by-side display, or
> > > the highlighting of differences within a line, or the merge facility?
> > 
> > I like the side-by-side display.  I hardly look at the left (previous) side
> > at all - it's a good way of seeing the change in a larger context.
> 
> I see.  There are a couple of features in gitk you might find useful,
> then: you can get the gitk diff window to display just the new
> version (or just the old version) using the radio buttons just above
> the diff pane.  You can also get it to show more context with the
> spinbox to the right of the radio buttons.
> 
> Something that dirdiff can do is to let you pick up the separator line
> and drag it upwards or downwards to see more context.  Maybe I should
> add that to gitk too.

I like to see the new code with lines-which-changed highlighted (the
tkdiff RHS).  But the LHS is useful sometimes too.

tkdiff works fine for me - I guess it's what you're used to.

eg: when I apply a patch with -F1 and it fails, then I apply it without
-F1 and it applies, I have to go in and check that the hunks which
didn't apply with -F1 actually landed in the right place.  So to find
hunk 14 of 24 I click tkdiff's 'Next' button 13 times.
