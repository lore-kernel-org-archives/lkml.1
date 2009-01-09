Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbZAIBy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbZAIBy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 20:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZAIByS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 20:54:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766AbZAIByR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 20:54:17 -0500
Date: Thu, 8 Jan 2009 17:53:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-Id: <20090108175338.2abbee16.akpm@linux-foundation.org>
In-Reply-To: <20090108165029.GA10951@infradead.org>
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk>
	<20090108165029.GA10951@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009 11:50:29 -0500 Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Jan 08, 2009 at 04:48:51PM +0000, Phillip Lougher wrote:
> > Please consider pulling my linux-next branch
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git
> > 
> > The patches have been posted to LKML and linux-fsdevel over the last
> > couple of months and have been reviewed and changed as requested.
> > Diffstat below.
> > 
> > Squashfs is a compressed read-only filesystem. It compresses metadata
> > and data, and uses up to 1 MiB block sizes for greater compression.
> 
> That seems pretty fast for something only posted this week and not
> even in -next.

I discussed this with Phillip a bit, and it looks like we'll go for a
2.6.21 merge.  This gives a couple of months for testing and review in
linux-next.

Of course, this assumes that someone will actually perform that testing
and review.  Chances are that it'll just sit there, getting nothing more
than compilation testing.

Apparently I reviewed the code a while back - that grey cell must have
died.  Does anyone else intend to review the code in that timeframe? 
If not, we might as well merge it now, if ever..

