Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab0BFWtw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 17:49:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756108Ab0BFWtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 17:49:50 -0500
Date: Sat, 6 Feb 2010 14:49:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc7
In-Reply-To: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain>
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Feb 2010, Linus Torvalds wrote:
> 
> But we've certainly fixed a few things, and it's been a week, so here's 
> -rc7. I wish I could say that it's the last -rc, but I strongly doubt 
> that, and we'll almost certainly have at least one more.

Oh, and I forgot to ask one thing I had intended to ask in the release 
notes..

Do people really care about the old-fashioned tar.gz and patch.gz files? 
I've always uploaded the tar-files and patches compressed with gzip, 
because that's the "traditional" way, and then we have a script that also 
re-compresses things as 'bz2' because it compresses better and many people 
are bandwidth-limited and much prefer the better compression.

Of course, if you really care about bandwidth, you're better off just 
fetching the git trees instead, but the question for non-git users is: 

   Would it be ok to _only_ have the 'bz2' patches and tar-balls?

Having two copies of every large file seems silly, if nobody really 
requires the traditional .gz format..

		Linus
