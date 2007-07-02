Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbXGBXN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbXGBXN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 19:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbXGBXNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 19:13:50 -0400
Received: from lazybastard.de ([212.112.238.170]:47840 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650AbXGBXNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 19:13:49 -0400
Date: Tue, 3 Jul 2007 01:04:18 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: vm/fs meetup in september?
Message-ID: <20070702230418.GA5630@lazybastard.org>
References: <20070624042345.GB20033@wotan.suse.de> <6934efce0706251708h7ab8d7dal6682def601a82073@mail.gmail.com> <20070626060528.GA15134@infradead.org> <6934efce0706261007x5e402eebvc528d2d39abd03a3@mail.gmail.com> <20070630093243.GD22354@infradead.org> <6934efce0707021044x44f51337ofa046c85e342a973@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6934efce0707021044x44f51337ofa046c85e342a973@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 July 2007 10:44:00 -0700, Jared Hulbert wrote:
> 
> >So what you mean is "swap on flash" ?  Defintively sounds like an
> >interesting topic, although I'm not too sure it's all that
> >filesystem-related.
> 
> Maybe not. Yet, it would be a very useful place to store data from a
> file as a non-volatile page cache.
> 
> Also it is something that I believe would benefit from a VFS-like API.
> I mean there is a consistent interface a management layer like this
> could use, yet the algorithms used to order the data and the interface
> to the physical media may vary.  There is no single right way to do
> the management layer, much like filesystems.
> 
> Given the page orientation of the current VFS seems to me like there
> might be a nice way to use it for this purpose.
> 
> Or maybe the real experts on this stuff can tell me how wrong that is
> and where it should go :)

I don't believe anyone has implemented this before, so any experts would
be self-appointed.

Maybe this should be turned into a filesystem subject after all.  The
complexity comes from combining XIP with writes on the same chip.  So
solving your problem should be identical to solving the rw XIP
filesystem problem.

If there is interest in the latter, I'd offer my self-appointed
expertise.

Jörn

-- 
Joern's library part 5:
http://www.faqs.org/faqs/compression-faq/part2/section-9.html
