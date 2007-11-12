Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbXKLHpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbXKLHpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 02:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXKLHpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 02:45:06 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58608 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751277AbXKLHpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 02:45:05 -0500
Date: Mon, 12 Nov 2007 08:44:41 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 5/6] MN10300: Add the MN10300/AM33 architecture to the
	kernel [try #5]
Message-ID: <20071112074441.GC9771@stusta.de>
References: <20071109195303.edbdc631.akpm@linux-foundation.org> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153458.20803.10594.stgit@warthog.procyon.org.uk> <24343.1194697130@redhat.com> <20071110114320.1fa6e94c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071110114320.1fa6e94c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 11:43:20AM -0800, Andrew Morton wrote:
> On Sat, 10 Nov 2007 12:18:50 +0000 David Howells <dhowells@redhat.com> wrote:
>...
> > has a couple of examples on it's front page.  If you work through the menus of
> > modern Panasonic tellies, you might find a URL pointing somewhere on this
> > website that isn't reachable by linking from the index page of the website.
> > 
> > I don't know who else uses this CPU, but it's possible MEI sell them to other
> > companies.
> 
> If it is indeed the case that this architecture is used internally by a
> single organisation then perhaps it doesn't make sense for us to merge it.
> 
> One of the main reasons we put code into the kernel is as a means of
> distribution: to get it into the hands of people who need it.  But in this
> situation there is no advantage to *anyone* from this merge apart from MEI.
> 
> IOW, the submitter gains and everyone else loses.  It's a curious situation.
>...

You miss the point that we want people to be able to use Linux in such 
situations.

There are basically two choices:
- Either tell them code won't get merged and offer some degree of API
  stability in exchange or
- allow all code with >= 1 users to enter the kernel. [1]

With the current development model (and the mere amount of changes 
merged), the first choice is not possible.

The only reason for not merging it [1] would be if it would be 
unmaintained and bitrot, but considering that David is already doing a 
good job at maintaining the frv port that's not an issue here.

cu
Adrian

[1] assuming the code itself is considered OK

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

