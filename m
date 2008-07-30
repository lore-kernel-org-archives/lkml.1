Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYG3JD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYG3JD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYG3JDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:03:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752753AbYG3JDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:03:15 -0400
Date: Wed, 30 Jul 2008 02:03:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Linux v2.6.27-rc1
Message-Id: <20080730020308.a552c4d8.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807290945030.3334@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
	<200807290927.12101.jbarnes@virtuousgeek.org>
	<alpine.LFD.1.10.0807290945030.3334@nehalem.linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 09:59:18 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

>  - I don't think the 'next' thing works as well for the occasional 
>    developer that just has a few patches pending as it works for subsystem 
>    maintainers that are used to it.

Those people's patches are in -mm, which now holds maybe 100 or more
"trees", many of which are small or empty.

My project within the next couple of weeks is to get most of that
material into linux-next.  Stephen will be involved ;)

>    IOW, I think 'next' needs enough infrastructure setup from the 
>    developer side that I don't think it's reasonable for _everything_ to 
>    go through next.

True.  But

a) some of the problematic changes which we've seen simply _should_
   have been in linux-next.  Some of them were even coming from
   developers whose trees are already in linux-next.

b) A lot of the bugs which hit your tree would have been quickly
   found in linux-next too.


But it's all shuffling deckchairs, really.  Are we actually merging
better code as a reasult of all of this?  Are we being more careful and
reviewing better and testing better?

Don't think so.

> And that in turn means that I'm not entirely thrilled 
>    when people then complain "that wasn't in next". I think people should 
>    accept that not everything will be in next.

Oh sure.  But it depends on the _reason_ why it wasn't in linux-next. 
If the reason is a good one then fine.  But if the reason is "I was too
slack", or "I only wrote it five minutes ago" then the system is good,
and the developer isn't.

