Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbZEKRRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbZEKRRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZEKRRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:17:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139AbZEKRRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:17:40 -0400
Date: Mon, 11 May 2009 10:13:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       sandeen@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] fiemap tester
Message-Id: <20090511101344.4aad2cda.akpm@linux-foundation.org>
In-Reply-To: <20090511094639.GA7488@infradead.org>
References: <20090508191649.GG9068@unused.rdu.redhat.com>
	<20090508161318.c73d766c.akpm@linux-foundation.org>
	<20090511094639.GA7488@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 05:46:39 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, May 08, 2009 at 04:13:18PM -0700, Andrew Morton wrote:
> > On Fri, 8 May 2009 15:16:49 -0400
> > Josef Bacik <josef@redhat.com> wrote:
> > 
> > > Here is small little program which I and Eric have been working on this week to
> > > better test FIEMAP
> > 
> > I for one wouldn't complain were someone to create
> > Documentation/fs/tests/ and to then start filling it with stuff.
> 
> Why oh why do people think Documentation/ is a good place for code?

I don't think anyone does.  But it's better than nothing.

> tests/ would be a much better place :)

Yup.

> Last time I brought the idea of a small in-tree test harness up at KS
> people weren't too fond of it, but if we get more backing now we could
> try it, otherwise we can just stick it into xfsqa which will hopefully
> soon be generalized to a general fs QA suite.

Well Sam had all this done in his tree six-odd months ago - moved all
the compileable stuff out of Documentation/ and into tests/ and we'd
shaken out pretty much all the problems I think.  But then he ran into
a busy spot and it didn't quite get finished and merged.

Hopefully that will all come back again sometime.  Until then, we keep
on plugging away with the current setup.

