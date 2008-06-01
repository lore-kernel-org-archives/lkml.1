Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbYFAVFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbYFAVFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYFAVEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:04:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbYFAVEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:04:52 -0400
Date: Sun, 1 Jun 2008 14:04:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: Re: Diagnosing linux-next (Was: Re: m68k libc5 regression)
Message-Id: <20080601140415.a2f25b9d.akpm@linux-foundation.org>
In-Reply-To: <20080601232638.fda1f3ab.sfr@canb.auug.org.au>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
	<Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
	<20080601005338.3affe880.akpm@linux-foundation.org>
	<20080601232638.fda1f3ab.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008 23:26:38 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Sun, 1 Jun 2008 00:53:38 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > I do not know how to work out how this patch got into linux-next.
> 
> I have been wondering for a while what I can do to make figuring this out
> (in general) easier.  Would adding the SHA1 of the head of each tree to
> the Trees file help?  I could publish all the branches in my linux-next
> repo - but they change daily.  I guess only the git users benefit from
> those suggestions.
> 
> gitk can tell you pretty easily (just find the offending commit and work
> your way upward until you find a merge by me).
> 

hm, I just found the `committer' line in gitk.  Coulda sworn that
wasn't there yesterday.
