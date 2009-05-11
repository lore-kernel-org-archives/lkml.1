Return-Path: <linux-kernel-owner+w=401wt.eu-S1757608AbZEKJrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbZEKJrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbZEKJqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:46:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55729 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbZEKJqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:46:51 -0400
Date: Mon, 11 May 2009 05:46:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       sandeen@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] fiemap tester
Message-ID: <20090511094639.GA7488@infradead.org>
References: <20090508191649.GG9068@unused.rdu.redhat.com> <20090508161318.c73d766c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508161318.c73d766c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 04:13:18PM -0700, Andrew Morton wrote:
> On Fri, 8 May 2009 15:16:49 -0400
> Josef Bacik <josef@redhat.com> wrote:
> 
> > Here is small little program which I and Eric have been working on this week to
> > better test FIEMAP
> 
> I for one wouldn't complain were someone to create
> Documentation/fs/tests/ and to then start filling it with stuff.

Why oh why do people think Documentation/ is a good place for code?

tests/ would be a much better place :)

Last time I brought the idea of a small in-tree test harness up at KS
people weren't too fond of it, but if we get more backing now we could
try it, otherwise we can just stick it into xfsqa which will hopefully
soon be generalized to a general fs QA suite.

