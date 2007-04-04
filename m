Return-Path: <linux-kernel-owner+w=401wt.eu-S2993018AbXDDSvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993018AbXDDSvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993028AbXDDSvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:51:37 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52147 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993018AbXDDSvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:51:35 -0400
Date: Wed, 4 Apr 2007 11:51:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
Message-Id: <20070404115105.ebaff52a.akpm@linux-foundation.org>
In-Reply-To: <20070404130918.GK2986@holomorphy.com>
References: <46128051.9000609@redhat.com>
	<p73648dz5oa.fsf@bingen.suse.de>
	<46128CC2.9090809@redhat.com>
	<20070403172841.GB23689@one.firstfloor.org>
	<20070403125903.3e8577f4.akpm@linux-foundation.org>
	<4612B645.7030902@redhat.com>
	<20070403202937.GE355@devserv.devel.redhat.com>
	<20070404130918.GK2986@holomorphy.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 06:09:18 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:

> 
> On Tue, Apr 03, 2007 at 04:29:37PM -0400, Jakub Jelinek wrote:
> > void *
> > tf (void *arg)
> > {
> >   (void) arg;
> >   size_t ps = sysconf (_SC_PAGE_SIZE);
> >   void *p = mmap (NULL, 128 * ps, PROT_READ | PROT_WRITE,
> >                   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> >   if (p == MAP_FAILED)
> >     exit (1);
> >   int i;
> 
> Oh dear.

what's all this about?
