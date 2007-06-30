Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbXF3Jcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbXF3Jcy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbXF3Jcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:32:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40499 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbXF3Jco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:32:44 -0400
Date: Sat, 30 Jun 2007 10:32:43 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: vm/fs meetup in september?
Message-ID: <20070630093243.GD22354@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jared Hulbert <jaredeh@gmail.com>, Nick Piggin <npiggin@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-fsdevel@vger.kernel.org
References: <20070624042345.GB20033@wotan.suse.de> <6934efce0706251708h7ab8d7dal6682def601a82073@mail.gmail.com> <20070626060528.GA15134@infradead.org> <6934efce0706261007x5e402eebvc528d2d39abd03a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6934efce0706261007x5e402eebvc528d2d39abd03a3@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 10:07:24AM -0700, Jared Hulbert wrote:
> If you have a large array of a non-volatile semi-writeable memory such
> as a highspeed NOR Flash or some of the similar emerging technologies
> in a system.  It would be useful to use that memory as an extension of
> RAM.  One of the ways you could do that is allow pages to be swapped
> out to this memory.  Once there these pages could be read directly,
> but would require a COW procedure on a write access.  The reason why I
> think this may be a vm/fs topic is that the hardware makes writing to
> this memory efficiently a non-trivial operation that requires
> management just like a filesystem.  Also it seems to me that there are
> probably overlaps between this topic and the recent filemap_xip.c
> discussions.

So what you mean is "swap on flash" ?  Defintively sounds like an
interesting topic, although I'm not too sure it's all that
filesystem-related.
