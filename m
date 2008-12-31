Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbYLaBtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbYLaBtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 20:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYLaBt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 20:49:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54285 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYLaBt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 20:49:27 -0500
Date: Wed, 31 Dec 2008 01:49:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] minix: fix add link - wrong position calculation
Message-ID: <20081231014923.GY28946@ZenIV.linux.org.uk>
References: <20081228232550.GA11504@rain> <20081230153230.8e72dc88.akpm@linux-foundation.org> <20081231012640.GA32239@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231012640.GA32239@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 02:26:41AM +0100, Nick Piggin wrote:
> > commit 4a66af9eaa9531372cfcb9e20103ed147c729ff9
> > Author:     Nick Piggin <npiggin@suse.de>
> > AuthorDate: Tue Oct 16 01:25:21 2007 -0700
> > Commit:     Linus Torvalds <torvalds@woody.linux-foundation.org>
> > CommitDate: Tue Oct 16 09:42:57 2007 -0700
> > 
> >     minixfs: convert to new aops
> > 
> > Is minixfs getting THAT little use, or is this bustage more subtle
> > than it appears?
> 
> Not getting used, I'd suspect (although I definitely have used it -- I
> converted it to large block size for testing fsblock, probably I didn't
> test softlinks).

Much simpler: there's one index for which the expressions are equivalent ;-)
Count how many entries does it take on minixfs to get to 4Kb.  Now think
how many had used that sucker on directories with >= 128 entries...

