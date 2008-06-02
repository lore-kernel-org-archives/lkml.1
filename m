Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbYFBFiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbYFBFiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 01:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYFBFiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 01:38:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbYFBFiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 01:38:07 -0400
Date: Sun, 1 Jun 2008 22:37:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: Re: Diagnosing linux-next (Was: Re: m68k libc5 regression)
Message-Id: <20080601223758.627e96e8.akpm@linux-foundation.org>
In-Reply-To: <18499.22285.159342.856006@cargo.ozlabs.ibm.com>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
	<Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
	<20080601005338.3affe880.akpm@linux-foundation.org>
	<20080601232638.fda1f3ab.sfr@canb.auug.org.au>
	<20080601140415.a2f25b9d.akpm@linux-foundation.org>
	<18499.16693.526974.912404@cargo.ozlabs.ibm.com>
	<20080601180616.75d1886e.akpm@linux-foundation.org>
	<18499.22285.159342.856006@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008 12:12:29 +1000 Paul Mackerras <paulus@samba.org> wrote:

> Andrew Morton writes:
> 
> > tkdiff-style diff viewer!
> > 
> > I mentioned that to you a year or two back, and you've probabably
> > already done it but nobody told me about it :)
> 
> There's now a facility for viewing diffs in an external viewer.  If
> you do Edit->Preferences and set the "External diff tool" thing to
> tkdiff, then you can right-click on a file name in the file list
> (bottom right-hand pane) and select "External diff" and it will launch
> tkdiff to show you the diffs for that file.

<upgrades>

OK, that works, thanks.  Right-clicking on each file is the sole way to
bring it up?

> What is it you like about tkdiff?  Is it the side-by-side display, or
> the highlighting of differences within a line, or the merge facility?

I like the side-by-side display.  I hardly look at the left (previous) side
at all - it's a good way of seeing the change in a larger context.
