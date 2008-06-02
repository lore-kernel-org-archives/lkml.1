Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbYFBFuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbYFBFuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 01:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYFBFuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 01:50:11 -0400
Received: from ozlabs.org ([203.10.76.45]:43920 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbYFBFuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 01:50:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18499.35335.408967.918602@cargo.ozlabs.ibm.com>
Date: Mon, 2 Jun 2008 15:49:59 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: Re: Diagnosing linux-next (Was: Re: m68k libc5 regression)
In-Reply-To: <20080601223758.627e96e8.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
	<Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
	<20080601005338.3affe880.akpm@linux-foundation.org>
	<20080601232638.fda1f3ab.sfr@canb.auug.org.au>
	<20080601140415.a2f25b9d.akpm@linux-foundation.org>
	<18499.16693.526974.912404@cargo.ozlabs.ibm.com>
	<20080601180616.75d1886e.akpm@linux-foundation.org>
	<18499.22285.159342.856006@cargo.ozlabs.ibm.com>
	<20080601223758.627e96e8.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> On Mon, 2 Jun 2008 12:12:29 +1000 Paul Mackerras <paulus@samba.org> wrote:
> > There's now a facility for viewing diffs in an external viewer.  If
> > you do Edit->Preferences and set the "External diff tool" thing to
> > tkdiff, then you can right-click on a file name in the file list
> > (bottom right-hand pane) and select "External diff" and it will launch
> > tkdiff to show you the diffs for that file.
> 
> <upgrades>
> 
> OK, that works, thanks.  Right-clicking on each file is the sole way to
> bring it up?

At the moment, yes.  Do you want something different?

> > What is it you like about tkdiff?  Is it the side-by-side display, or
> > the highlighting of differences within a line, or the merge facility?
> 
> I like the side-by-side display.  I hardly look at the left (previous) side
> at all - it's a good way of seeing the change in a larger context.

I see.  There are a couple of features in gitk you might find useful,
then: you can get the gitk diff window to display just the new
version (or just the old version) using the radio buttons just above
the diff pane.  You can also get it to show more context with the
spinbox to the right of the radio buttons.

Something that dirdiff can do is to let you pick up the separator line
and drag it upwards or downwards to see more context.  Maybe I should
add that to gitk too.

Paul.
