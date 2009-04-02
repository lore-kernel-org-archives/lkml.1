Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbZDBLeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbZDBLeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbZDBLeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:34:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:43349 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbZDBLeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:34:05 -0400
Date: Thu, 2 Apr 2009 13:34:01 +0200
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ying Han <yinghan@google.com>, "Martin J. Bligh" <mbligh@mbligh.org>,
       linux-ext4@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Message-ID: <20090402113400.GC3010@duck.suse.cz>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <20090324173511.GJ23439@duck.suse.cz> <604427e00904011536i6332a239pe21786cc4c8b3025@mail.gmail.com> <200904022224.31060.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904022224.31060.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 02-04-09 22:24:29, Nick Piggin wrote:
> On Thursday 02 April 2009 09:36:13 Ying Han wrote:
> > Hi Jan:
> >     I feel that the problem you saw is kind of differnt than mine. As
> > you mentioned that you saw the PageError() message, which i don't see
> > it on my system. I tried you patch(based on 2.6.21) on my system and
> > it runs ok for 2 days, Still, since i don't see the same error message
> > as you saw, i am not convineced this is the root cause at least for
> > our problem. I am still looking into it.
> >     So, are you seeing the PageError() every time the problem happened?
> 
> So I asked if you could test with my workaround of taking truncate_mutex
> at the start of ext2_get_blocks, and report back. I never heard of any
> response after that.
> 
> To reiterate: I was able to reproduce a problem with ext2 (I was testing
> on brd to get IO rates high enough to reproduce it quite frequently).
> I think I narrowed the problem down to block allocation or inode block
> tree corruption because I was unable to reproduce it with that hack in
> place.
  Nick, what load did you use for reproduction? I'll try to reproduce it
here so that I can debug ext2...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
