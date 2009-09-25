Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbZIYBDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbZIYBDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 21:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZIYBDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 21:03:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbZIYBDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 21:03:48 -0400
Date: Thu, 24 Sep 2009 18:01:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       lethal@linux-sh.org, mel@csn.ul.ie, gerg@snapgear.com,
       stable@kernel.org
Subject: Re: [PATCH] NOMMU: Fix MAP_PRIVATE mmap() of objects where the data
 can be mapped directly
Message-Id: <20090924180128.1fa8c0d8.akpm@linux-foundation.org>
In-Reply-To: <8852.1253839157@redhat.com>
References: <20090924150925.06f4fa23.akpm@linux-foundation.org>
	<20090924141310.19746.31678.stgit@warthog.procyon.org.uk>
	<8852.1253839157@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009 01:39:17 +0100 David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > Note that this fix does the following commit differently:
> > > 
> > > 	commit a190887b58c32d19c2eee007c5eb8faa970a69ba
> > > 	Author: David Howells <dhowells@redhat.com>
> > > 	Date:   Sat Sep 5 11:17:07 2009 -0700
> > > 	nommu: fix error handling in do_mmap_pgoff()
> > 
> > I don't understand what you're saying here.
> 
> Sorry, I was attempting to point out that this appears to revert some of that
> patch - whilst this is true, it then implements the fix differently.
> 

OK.

And what are your opinions on the -stable desirability?
