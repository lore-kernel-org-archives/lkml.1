Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbXJXCpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbXJXCpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbXJXCpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:45:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbXJXCpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:45:31 -0400
Date: Tue, 23 Oct 2007 19:45:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Message-Id: <20071023194527.4ac1dc85.akpm@linux-foundation.org>
In-Reply-To: <20071024023035.GV27248@parisc-linux.org>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx>
	<alpine.LFD.0.999.0710231641480.30120@woody.linux-foundation.org>
	<20071024023035.GV27248@parisc-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 20:30:35 -0600 Matthew Wilcox <matthew@wil.cx> wrote:

> It's a matter of taste ... some people prefer to use accessors for
> everything, other people prefer to expose the underlying structure
> directly.

Experience tells us that when you use accessors you end up thanking
yourself later on.  Especially when diddling struct page ;)

Although one really should make a best-effort guess at "how likely is
this to change in the future".  If the implementation-to-be-copied
has been out there for a while then "not very" is a good answer.

But hey, don't listen to me - I like C++, and approve of Java.

