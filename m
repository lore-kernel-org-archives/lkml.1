Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZBBKkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZBBKkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 05:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZBBKkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 05:40:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZBBKkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 05:40:07 -0500
Subject: Re: [BUG??] Deadlock between kswapd and
 sys_inotify_add_watch(lockdep  report)
From: Peter Zijlstra <peterz@infradead.org>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>, linux kernel <linux-kernel@vger.kernel.org>,
       linux mm <linux-mm@kvack.org>
In-Reply-To: <28c262360902020225w6419089ft2dda30da9dfb32a9@mail.gmail.com>
References: <20090202101735.GA12757@barrios-desktop>
	 <28c262360902020225w6419089ft2dda30da9dfb32a9@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 11:40:02 +0100
Message-Id: <1233571202.4787.124.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 19:25 +0900, MinChan Kim wrote:
> But, I am not sure whether it's real bug or not.

Me neither, inode life-times are tricky, but on first sight it looks
real enough.

> I always suffer from reading lockdep report's result. :(
> It would be better to have a document about lockdep report analysis.

I've never found them hard to read, so I'm afraid you'll have to be more
explicit about what is unclear to you.

