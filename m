Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbZIOAbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbZIOAbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 20:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbZIOAbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 20:31:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757630AbZIOAbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 20:31:31 -0400
Date: Mon, 14 Sep 2009 17:31:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Joel Becker <Joel.Becker@oracle.com>
cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <20090915000417.GC4507@mail.oracle.com>
Message-ID: <alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
References: <20090911200458.GA15416@mail.oracle.com> <alpine.LFD.2.01.0909141417180.4950@localhost.localdomain> <20090914221434.GA4507@mail.oracle.com> <alpine.LFD.2.01.0909141614350.4950@localhost.localdomain> <20090915000417.GC4507@mail.oracle.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Sep 2009, Joel Becker wrote:
> 
> 	It's creating a new entry in the name space based on an old one.

That's just a cumbersome way of saying "copyfile".

Here's a challenge for you: go outside, take the first five people you 
meet at random, and ask them what a 'copyfile()' system call would do.

Then, do the same thing with 'reflink()'.

Feel free to stack the deck, so that the people you ask about 'reflink()' 
actually know computers.

Then report back which group guessed better what the system call does.

> 	reflink doesn't merely guarantee atomicity, it guarantees the
> shared data extents.

Why?

That just limits its usefulness. What's the reason for that sophistry, 
except to try to argue for a name that makes no sense?

> 	Well, obviously I started from the fact that we don't have
> flink().  But it doesn't really fit anyway.  reflink is a namespace
> operation - give me a new item in the namespace that shares the data
> extents of the old item.

That's not a namespace op, EXCEPT FOR THE NEW NAME.

The data you share from has no namespace component to it, except as a 
lookup. But a 'fd' is equally descriptive of the shared data.

		Linus
